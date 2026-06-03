════════════════════════════════════════════════════════════════════════════════
🐰 RABBITMQ - CONFIGURATION COMPLÈTE & GUIDE OPÉRATIONNEL
════════════════════════════════════════════════════════════════════════════════

✅ CONFIGURATION APPLIQUÉE AVEC SUCCÈS

════════════════════════════════════════════════════════════════════════════════
1. ACCÈS & CREDENTIALS
════════════════════════════════════════════════════════════════════════════════

URL Management: http://localhost:31672
Username: guest
Password: guest

RabbitMQ Version: 3.12.14
Erlang Version: 25.3.2.15

════════════════════════════════════════════════════════════════════════════════
2. ARCHITECTURE CRÉÉE
════════════════════════════════════════════════════════════════════════════════

3 EXCHANGES:
─────────────

1. education.events (Topic Exchange)
   └─ Type: Topic
   └─ Durable: Yes
   └─ Routing Keys: user.*, activity.*, payment.*, email.*
   └─ Use Case: Event streaming for services that need topic-based routing

2. education.direct (Direct Exchange)
   └─ Type: Direct
   └─ Durable: Yes
   └─ Routing Keys: classroom (1:1 routing)
   └─ Use Case: Point-to-point messaging for classroom notifications

3. education.fanout (Fanout Exchange)
   └─ Type: Fanout
   └─ Durable: Yes
   └─ Routing Keys: N/A (broadcasts to all queues)
   └─ Use Case: System-wide announcements, broadcasts

5 QUEUES:
─────────

1. user.events
   └─ Binding: education.events (user.*)
   └─ TTL: 1 hour
   └─ Max Length: 100,000 messages
   └─ Purpose: Store user login, logout, profile updates

2. activity.logs
   └─ Binding: education.events (activity.*)
   └─ TTL: 30 minutes
   └─ Max Length: 500,000 messages
   └─ Purpose: Student activity tracking, course progress

3. classroom.notifications
   └─ Binding: education.direct (classroom)
   └─ TTL: 10 minutes
   └─ Max Length: 50,000 messages
   └─ Purpose: Real-time classroom announcements

4. payment.transactions
   └─ Binding: education.events (payment.*)
   └─ TTL: 24 hours
   └─ Max Length: 200,000 messages
   └─ Purpose: Payment processing, billing records

5. email.queue
   └─ Binding: education.events (email.*)
   └─ TTL: 7 days
   └─ Max Length: 100,000 messages
   └─ Purpose: Email notifications, forgot password, registration

════════════════════════════════════════════════════════════════════════════════
3. MESSAGE FLOW EXAMPLES
════════════════════════════════════════════════════════════════════════════════

SCENARIO 1: User Login Event
─────────────────────────────

Flow:
  User Service → Publish to education.events with routing_key: "user.login"
  ↓
  RabbitMQ matches "user.login" to "user.*" pattern
  ↓
  Message goes to: user.events queue
  ↓
  Consumer (Analytics Service) reads from user.events
  ↓
  Record logged to database

Code Example (Node.js):
  const msg = { userId: 123, action: "login", timestamp: Date.now() };
  await channel.publish('education.events', 'user.login', Buffer.from(JSON.stringify(msg)));

SCENARIO 2: Activity Tracking
──────────────────────────────

Flow:
  Student takes quiz → Activity Service publishes to education.events
  Routing key: "activity.quiz_submitted"
  ↓
  Matches pattern "activity.*"
  ↓
  Goes to: activity.logs queue
  ↓
  Multiple consumers can read simultaneously:
    • Analytics Service
    • Reporting Service
    • Real-time Dashboard

Code Example:
  await channel.publish('education.events', 'activity.quiz_submitted', 
    Buffer.from(JSON.stringify({ studentId, quizId, score, timestamp })));

SCENARIO 3: Classroom Notification
───────────────────────────────────

Flow:
  Teacher sends announcement → Publish to education.direct
  Routing key: "classroom"
  ↓
  Direct routing (specific queue only)
  ↓
  Goes to: classroom.notifications
  ↓
  Notification Service reads and pushes to connected students in real-time

Code Example:
  await channel.publish('education.direct', 'classroom',
    Buffer.from(JSON.stringify({ classroomId, message, teacher })));

SCENARIO 4: Payment Processing
──────────────────────────────

Flow:
  Student pays for course → Payment Service publishes to education.events
  Routing key: "payment.subscription_purchase"
  ↓
  Matches "payment.*"
  ↓
  Goes to: payment.transactions queue
  ↓
  Multiple services consume:
    • Billing Service (records payment)
    • Email Service (sends receipt)
    • Analytics (tracks revenue)
    • Notification Service (sends confirmation)

════════════════════════════════════════════════════════════════════════════════
4. PERFORMANCE CONFIGURATION
════════════════════════════════════════════════════════════════════════════════

TTL (Time To Live) Settings:
────────────────────────────

user.events: 1 hour (3,600,000 ms)
  └─ Reason: User events only relevant for current session
  └─ Auto-deleted after 1 hour

activity.logs: 30 minutes (1,800,000 ms)
  └─ Reason: Real-time analytics, old data goes to Elasticsearch
  └─ Prevents queue buildup

classroom.notifications: 10 minutes (600,000 ms)
  └─ Reason: Time-sensitive classroom announcements
  └─ Must be delivered quickly or becomes irrelevant

payment.transactions: 24 hours (86,400,000 ms)
  └─ Reason: Payment integrity requires longer retention
  └─ Must guarantee delivery even if payment service is down

email.queue: 7 days (604,800,000 ms)
  └─ Reason: Email retry logic needs messages available
  └─ Must support retries with exponential backoff

Max Length Constraints:
──────────────────────

activity.logs: 500,000 max (largest, highest volume)
payment.transactions: 200,000 max (important, medium volume)
user.events: 100,000 max
email.queue: 100,000 max
classroom.notifications: 50,000 max (lowest, time-sensitive)

Behavior when limit reached:
  → FIFO: Oldest messages deleted first
  → Prevents memory overflow
  → No messages lost after TTL expires anyway

════════════════════════════════════════════════════════════════════════════════
5. SCALING CONSIDERATIONS
════════════════════════════════════════════════════════════════════════════════

Current Setup:
├─ Single RabbitMQ node
├─ Perfect for development/small production
└─ Can handle ~1,000s of messages/second

For Scale-Up (1 million+ events/day):

1. RabbitMQ Clustering:
   └─ Run 3 RabbitMQ nodes in HA cluster
   └─ Automatic failover
   └─ Message replication

2. Sharding Queues:
   └─ Split activity.logs into activity.logs.1, activity.logs.2, etc.
   └─ Load balance across shards
   └─ Horizontal scaling

3. Dead Letter Exchanges:
   └─ Configure DLX for failed messages
   └─ Automatic retry with backoff
   └─ Prevent message loss

4. Connection Pooling:
   └─ Services use connection pools
   └─ Reuse TCP connections
   └─ Reduce overhead

════════════════════════════════════════════════════════════════════════════════
6. MONITORING & HEALTH CHECKS
════════════════════════════════════════════════════════════════════════════════

Key Metrics to Monitor:
──────────────────────

1. Queue Depth:
   └─ Alert if any queue > 80% of max_length
   └─ Indicates slow consumers or publishing spike

2. Ready Messages:
   └─ Alert if ready messages > 10,000
   └─ Suggests backup in processing

3. Unacked Messages:
   └─ Alert if unacked > 1,000
   └─ Indicates consumer processing issues

4. Connection Count:
   └─ Alert if connections drop suddenly
   └─ Could indicate service crash

5. Memory Usage:
   └─ Keep below 50% of RabbitMQ memory limit
   └─ Above 50% = trigger scaling

View in Management UI:
  1. Go to http://localhost:31672
  2. Click "Queues"
  3. Check:
     • Name Ready Unacked Total
     • user.events: 0 0 0 (ideal)
     • activity.logs: <50000 <5000 <55000 (good)

════════════════════════════════════════════════════════════════════════════════
7. TROUBLESHOOTING
════════════════════════════════════════════════════════════════════════════════

Problem 1: Messages not being consumed
─────────────────────────────────────
Solution:
  1. Check if consumer is connected: Management UI → Connections
  2. Verify routing key matches queue binding
  3. Check if queue is marked as "exclusive"
  4. Look at consumer prefetch count (ack settings)

Problem 2: Queue growing too large
──────────────────────────────────
Solution:
  1. Check consumer throughput (Messages/sec)
  2. Verify consumer isn't crashing silently
  3. Check network connectivity between services
  4. Scale up consumers or add more instances

Problem 3: Messages expiring without processing
────────────────────────────────────────────────
Solution:
  1. Increase TTL for that queue type
  2. Add more consumer instances
  3. Check consumer error logs
  4. Verify message format is correct

Problem 4: Connection refused
────────────────────────────
Solution:
  1. Verify RabbitMQ is running: kubectl get pods -n message-queue
  2. Check port: kubectl get svc -n message-queue
  3. Test connection: telnet localhost 5672
  4. Check RabbitMQ logs: kubectl logs -n message-queue <pod>

════════════════════════════════════════════════════════════════════════════════
8. USAGE PATTERNS FOR YOUR SERVICES
════════════════════════════════════════════════════════════════════════════════

AUTH SERVICE:
├─ Publish: user.login, user.logout to education.events
├─ Consume: email.queue (for 2FA emails)
└─ Pattern: Topic-based routing

STUDENT SERVICE:
├─ Publish: activity.* to education.events
├─ Consume: None (fire & forget)
└─ Pattern: Event streaming

TEACHER SERVICE:
├─ Publish: activity.teacher_post to education.events
├─ Consume: classroom.notifications (receive announcements)
└─ Pattern: Hybrid (publish topic + consume direct)

CLASSROOM SERVICE:
├─ Publish: classroom announcements to education.direct
├─ Consume: classroom.notifications (announcements from other teachers)
└─ Pattern: Direct point-to-point

PAYMENT SERVICE:
├─ Publish: payment.* events to education.events
├─ Consume: None (fire & forget)
└─ Pattern: Event streaming with long TTL

NOTIFICATION SERVICE:
├─ Publish: Nothing
├─ Consume: email.queue, classroom.notifications
└─ Pattern: Centralized consumer

════════════════════════════════════════════════════════════════════════════════
9. COMMANDES UTILES
════════════════════════════════════════════════════════════════════════════════

Check RabbitMQ Status:
  kubectl get pods -n message-queue
  kubectl describe pod -n message-queue <rabbitmq-pod>

View Logs:
  kubectl logs -n message-queue <pod> --tail=100

Access Management UI:
  http://localhost:31672
  Username: guest
  Password: guest

Delete Queue:
  1. Management UI → Queues
  2. Click queue name
  3. Click "Delete" button

Purge Queue (delete all messages):
  1. Management UI → Queues
  2. Click queue name
  3. Click "Purge" button

Test Publishing:
  Use Management UI → Queues → Select Queue → "Publish message"

════════════════════════════════════════════════════════════════════════════════
10. BEST PRACTICES
════════════════════════════════════════════════════════════════════════════════

✅ DO:

1. Use descriptive routing keys:
   ✓ user.login, user.logout (good)
   ✗ u.login (bad - not clear)

2. Set appropriate TTL:
   ✓ Longer for critical (payment, email)
   ✓ Shorter for real-time (notifications)

3. Use durable queues:
   ✓ Always enable durability for production

4. Implement error handling:
   ✓ Catch exceptions when publishing
   ✓ Implement retry logic for consumers

5. Monitor queue depths:
   ✓ Set up alerts for high queue backlog

❌ DON'T:

1. Use default guest account in production:
   ✗ Create specific users with limited permissions

2. Set TTL to 0 (immediate expiry):
   ✗ Messages would expire instantly

3. Ignore max_length limits:
   ✗ Queue memory grows unbounded

4. Publish without error handling:
   ✗ Silent failures = data loss

5. Use fanout for point-to-point:
   ✗ Topic or Direct exchanges are more efficient

════════════════════════════════════════════════════════════════════════════════
11. NEXT STEPS
════════════════════════════════════════════════════════════════════════════════

1. ✅ Configuration appliquée
2. ✅ Exchanges et queues créées
3. ✅ Bindings configurées
4. → Next: Test avec des messages
5. → Then: Intégrer avec vos microservices
6. → Finally: Monitor en production

════════════════════════════════════════════════════════════════════════════════
