════════════════════════════════════════════════════════════════════════════════
💻 RABBITMQ - CODE EXAMPLES POUR VOS MICROSERVICES
════════════════════════════════════════════════════════════════════════════════

CONFIGURATION POUR CHAQUE SERVICE

════════════════════════════════════════════════════════════════════════════════
1. AUTH SERVICE (Node.js)
════════════════════════════════════════════════════════════════════════════════

Purpose: Publish user login/logout events

Code:
────

const amqp = require('amqplib');

class AuthRabbitMQ {
  constructor() {
    this.connection = null;
    this.channel = null;
  }

  async connect() {
    this.connection = await amqp.connect('amqp://guest:guest@rabbitmq.message-queue.svc.cluster.local');
    this.channel = await this.connection.createChannel();
    await this.channel.assertExchange('education.events', 'topic', { durable: true });
  }

  async publishUserLogin(userId, ipAddress, device) {
    const message = {
      userId,
      action: 'login',
      ipAddress,
      device,
      timestamp: new Date().toISOString()
    };
    
    this.channel.publish(
      'education.events',
      'user.login',
      Buffer.from(JSON.stringify(message))
    );
    console.log('[AUTH] Published user.login:', message);
  }

  async publishUserLogout(userId) {
    const message = {
      userId,
      action: 'logout',
      timestamp: new Date().toISOString()
    };
    
    this.channel.publish(
      'education.events',
      'user.logout',
      Buffer.from(JSON.stringify(message))
    );
    console.log('[AUTH] Published user.logout:', message);
  }

  async consumeEmailQueue(callback) {
    await this.channel.assertQueue('email.queue', { durable: true });
    
    this.channel.consume('email.queue', async (msg) => {
      const emailData = JSON.parse(msg.content.toString());
      console.log('[AUTH] Received email task:', emailData);
      
      try {
        await callback(emailData);
        this.channel.ack(msg);
      } catch (error) {
        console.error('Error processing email:', error);
        this.channel.nack(msg, false, true); // Requeue on error
      }
    });
  }
}

// Usage in your auth routes:
const authRabbit = new AuthRabbitMQ();
await authRabbit.connect();

// On login:
router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  // ... validate credentials ...
  const user = await User.findByEmail(email);
  
  // Publish event to RabbitMQ
  await authRabbit.publishUserLogin(user.id, req.ip, req.headers['user-agent']);
  
  res.json({ token: generateJWT(user) });
});

// On logout:
router.post('/logout', async (req, res) => {
  const userId = req.user.id;
  await authRabbit.publishUserLogout(userId);
  res.json({ success: true });
});

════════════════════════════════════════════════════════════════════════════════
2. STUDENT SERVICE (Python)
════════════════════════════════════════════════════════════════════════════════

Purpose: Publish student activity events

Code:
────

import pika
import json
from datetime import datetime

class StudentRabbitMQ:
    def __init__(self):
        self.connection = None
        self.channel = None
    
    def connect(self):
        credentials = pika.PlainCredentials('guest', 'guest')
        parameters = pika.ConnectionParameters(
            host='rabbitmq.message-queue.svc.cluster.local',
            port=5672,
            credentials=credentials
        )
        self.connection = pika.BlockingConnection(parameters)
        self.channel = self.connection.channel()
        self.channel.exchange_declare(
            exchange='education.events',
            exchange_type='topic',
            durable=True
        )
    
    def publish_quiz_submitted(self, student_id, quiz_id, score, time_taken):
        message = {
            'studentId': student_id,
            'quizId': quiz_id,
            'score': score,
            'timeTaken': time_taken,
            'timestamp': datetime.utcnow().isoformat() + 'Z'
        }
        
        self.channel.basic_publish(
            exchange='education.events',
            routing_key='activity.quiz_submitted',
            body=json.dumps(message)
        )
        print(f'[STUDENT] Published activity.quiz_submitted: {message}')
    
    def publish_course_started(self, student_id, course_id):
        message = {
            'studentId': student_id,
            'courseId': course_id,
            'action': 'course_started',
            'timestamp': datetime.utcnow().isoformat() + 'Z'
        }
        
        self.channel.basic_publish(
            exchange='education.events',
            routing_key='activity.course_started',
            body=json.dumps(message)
        )
        print(f'[STUDENT] Published activity.course_started: {message}')
    
    def publish_assignment_submitted(self, student_id, assignment_id, grade):
        message = {
            'studentId': student_id,
            'assignmentId': assignment_id,
            'grade': grade,
            'timestamp': datetime.utcnow().isoformat() + 'Z'
        }
        
        self.channel.basic_publish(
            exchange='education.events',
            routing_key='activity.assignment_submitted',
            body=json.dumps(message)
        )
        print(f'[STUDENT] Published activity.assignment_submitted: {message}')

# Usage in your Flask/Django app:
student_rabbit = StudentRabbitMQ()
student_rabbit.connect()

# In quiz endpoint:
@app.route('/api/quiz/<quiz_id>/submit', methods=['POST'])
def submit_quiz(quiz_id):
    student_id = request.user.id
    score = calculate_score(request.json)
    time_taken = request.json.get('timeTaken')
    
    # Save to database...
    student_rabbit.publish_quiz_submitted(student_id, quiz_id, score, time_taken)
    
    return jsonify({'score': score})

════════════════════════════════════════════════════════════════════════════════
3. CLASSROOM SERVICE (Go)
════════════════════════════════════════════════════════════════════════════════

Purpose: Publish and consume classroom notifications

Code:
────

package main

import (
	"encoding/json"
	"log"
	"time"

	"github.com/streadway/amqp"
)

type ClassroomRabbit struct {
	connection *amqp.Connection
	channel    *amqp.Channel
}

type ClassroomMessage struct {
	ClassroomID string    `json:"classroomId"`
	Message     string    `json:"message"`
	Teacher     string    `json:"teacher"`
	Priority    string    `json:"priority"`
	Timestamp   time.Time `json:"timestamp"`
}

func (cr *ClassroomRabbit) Connect() error {
	var err error
	cr.connection, err = amqp.Dial("amqp://guest:guest@rabbitmq.message-queue.svc.cluster.local:5672/")
	if err != nil {
		return err
	}

	cr.channel, err = cr.connection.Channel()
	if err != nil {
		return err
	}

	// Declare exchange
	err = cr.channel.ExchangeDeclare(
		"education.direct",
		"direct",
		true,
		false,
		false,
		false,
		nil,
	)
	return err
}

func (cr *ClassroomRabbit) PublishAnnouncement(classroomID, message, teacher string) error {
	msg := ClassroomMessage{
		ClassroomID: classroomID,
		Message:     message,
		Teacher:     teacher,
		Priority:    "high",
		Timestamp:   time.Now().UTC(),
	}

	body, _ := json.Marshal(msg)

	return cr.channel.Publish(
		"education.direct",
		"classroom",
		false,
		false,
		amqp.Publishing{
			ContentType: "application/json",
			Body:        body,
		},
	)
}

func (cr *ClassroomRabbit) ConsumeNotifications(callback func(ClassroomMessage)) error {
	// Declare queue
	queue, err := cr.channel.QueueDeclare(
		"classroom.notifications",
		true,
		false,
		false,
		false,
		nil,
	)
	if err != nil {
		return err
	}

	// Declare consumer
	msgs, err := cr.channel.Consume(
		queue.Name,
		"",
		true,
		false,
		false,
		false,
		nil,
	)
	if err != nil {
		return err
	}

	go func() {
		for d := range msgs {
			var msg ClassroomMessage
			json.Unmarshal(d.Body, &msg)
			log.Printf("[CLASSROOM] Received: %+v\n", msg)
			callback(msg)
		}
	}()

	return nil
}

// Usage:
func main() {
	rabbit := &ClassroomRabbit{}
	rabbit.Connect()
	defer rabbit.connection.Close()

	// Publish announcement
	rabbit.PublishAnnouncement("classroom-101", "Quiz starting in 5 minutes", "Mrs. Smith")

	// Consume notifications
	rabbit.ConsumeNotifications(func(msg ClassroomMessage) {
		// Push to connected WebSocket clients
		broadcastToClassroom(msg.ClassroomID, msg)
	})

	select {} // Keep running
}

════════════════════════════════════════════════════════════════════════════════
4. PAYMENT SERVICE (Java)
════════════════════════════════════════════════════════════════════════════════

Purpose: Publish payment transactions

Code:
────

import com.rabbitmq.client.*;
import com.google.gson.Gson;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class PaymentRabbitMQ {
    private Connection connection;
    private Channel channel;
    private Gson gson = new Gson();

    public void connect() throws Exception {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("rabbitmq.message-queue.svc.cluster.local");
        factory.setPort(5672);
        factory.setUsername("guest");
        factory.setPassword("guest");
        
        connection = factory.newConnection();
        channel = connection.createChannel();
        
        channel.exchangeDeclare("education.events", "topic", true);
    }

    public static class PaymentMessage {
        public String transactionId;
        public String userId;
        public double amount;
        public String status;
        public String course;
        public String timestamp;

        public PaymentMessage(String transactionId, String userId, double amount, 
                            String course) {
            this.transactionId = transactionId;
            this.userId = userId;
            this.amount = amount;
            this.status = "completed";
            this.course = course;
            this.timestamp = LocalDateTime.now().format(
                DateTimeFormatter.ISO_DATE_TIME) + "Z";
        }
    }

    public void publishPayment(String transactionId, String userId, double amount, 
                               String course) throws IOException {
        PaymentMessage msg = new PaymentMessage(transactionId, userId, amount, course);
        String json = gson.toJson(msg);
        
        channel.basicPublish(
            "education.events",
            "payment.subscription_purchase",
            null,
            json.getBytes()
        );
        
        System.out.println("[PAYMENT] Published payment.subscription_purchase: " + json);
    }

    public void close() throws IOException {
        channel.close();
        connection.close();
    }
}

// Usage in Spring Boot:
@RestController
@RequestMapping("/api/payments")
public class PaymentController {
    private PaymentRabbitMQ paymentRabbit;

    @Autowired
    public PaymentController(PaymentRabbitMQ paymentRabbit) {
        this.paymentRabbit = paymentRabbit;
    }

    @PostMapping("/checkout")
    public ResponseEntity<?> checkout(@RequestBody PaymentRequest request) {
        // Process payment...
        String transactionId = generateTransactionId();
        boolean success = processPayment(request);
        
        if (success) {
            paymentRabbit.publishPayment(
                transactionId,
                request.getUserId(),
                request.getAmount(),
                request.getCourse()
            );
            return ResponseEntity.ok("Payment successful");
        }
        return ResponseEntity.status(400).body("Payment failed");
    }
}

════════════════════════════════════════════════════════════════════════════════
5. NOTIFICATION SERVICE (Multi-Language Consumer)
════════════════════════════════════════════════════════════════════════════════

Purpose: Consume from email.queue and send emails

Node.js Code:
─────────────

const nodemailer = require('nodemailer');
const amqp = require('amqplib');

class NotificationService {
  constructor() {
    this.mailer = nodemailer.createTransporter({
      host: 'smtp.gmail.com',
      port: 587,
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
      }
    });
  }

  async connectRabbitMQ() {
    const conn = await amqp.connect('amqp://guest:guest@rabbitmq.message-queue.svc.cluster.local');
    const ch = await conn.createChannel();
    
    // Consume from email.queue
    await ch.assertQueue('email.queue', { durable: true });
    
    ch.consume('email.queue', async (msg) => {
      const emailTask = JSON.parse(msg.content.toString());
      
      try {
        await this.sendEmail(emailTask);
        ch.ack(msg);
        console.log('[NOTIFICATION] Email sent:', emailTask.to);
      } catch (error) {
        console.error('[NOTIFICATION] Error:', error);
        
        // Requeue with exponential backoff
        const retries = (emailTask.retries || 0) + 1;
        if (retries < (emailTask.maxRetries || 3)) {
          emailTask.retries = retries;
          ch.nack(msg, false, true); // Requeue
        } else {
          ch.ack(msg); // Give up after max retries
        }
      }
    });
  }

  async sendEmail(task) {
    const { to, subject, template, data } = task;
    const html = this.renderTemplate(template, data);
    
    return this.mailer.sendMail({
      from: process.env.EMAIL_FROM,
      to,
      subject,
      html
    });
  }

  renderTemplate(template, data) {
    // Your template rendering logic
    const templates = {
      payment_receipt: `<h1>Payment Confirmed</h1><p>Thank you for purchasing ${data.courseId}!</p>`,
      password_reset: `<h1>Reset your password</h1><a href="${data.resetLink}">Click here</a>`,
      registration: `<h1>Welcome!</h1><p>Your account has been created.</p>`
    };
    
    return templates[template] || '';
  }
}

// Start service
const notificationService = new NotificationService();
notificationService.connectRabbitMQ().catch(console.error);

════════════════════════════════════════════════════════════════════════════════
✅ DEPLOYMENT CHECKLIST
════════════════════════════════════════════════════════════════════════════════

Before deploying each service:

☐ Install RabbitMQ client library for your language
☐ Add connection string to environment variables
☐ Implement error handling (try/catch, retry logic)
☐ Test locally against RabbitMQ
☐ Update Kubernetes manifests with env vars
☐ Deploy and verify messages flow through RabbitMQ

════════════════════════════════════════════════════════════════════════════════
