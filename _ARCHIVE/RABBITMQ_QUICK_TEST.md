════════════════════════════════════════════════════════════════════════════════
🧪 RABBITMQ - GUIDE DE TEST RAPIDE
════════════════════════════════════════════════════════════════════════════════

VÉRIFIEZ LA CONFIGURATION ACTUELLE
════════════════════════════════════════════════════════════════════════════════

1. Allez à: http://localhost:31672

2. Login:
   Username: guest
   Password: guest

3. Vous devriez voir:

   OVERVIEW:
   ├─ RabbitMQ 3.12.14
   ├─ Erlang 25.3.2.15
   ├─ Disk free: [high value]
   └─ Memory: [low value]

   QUEUES (5 queues):
   ├─ ✅ user.events
   ├─ ✅ activity.logs
   ├─ ✅ classroom.notifications
   ├─ ✅ payment.transactions
   └─ ✅ email.queue

   EXCHANGES (3 exchanges):
   ├─ ✅ education.events (topic)
   ├─ ✅ education.direct (direct)
   └─ ✅ education.fanout (fanout)

════════════════════════════════════════════════════════════════════════════════
TEST 1: PUBLISH A MESSAGE (UI Method)
════════════════════════════════════════════════════════════════════════════════

1. Go to: http://localhost:31672/#/queues

2. Click "Queues" tab

3. Find: "user.events"

4. Scroll down to "Publish message" section

5. Click in the message field and paste:
   {
     "userId": 123,
     "action": "login",
     "timestamp": "2026-05-29T14:00:00Z",
     "source": "web"
   }

6. Click "Publish message"

7. RESULT: Message should appear in queue count

8. Verify:
   • Queue "user.events" shows "1 Ready"
   • Message count increases

════════════════════════════════════════════════════════════════════════════════
TEST 2: VIEW MESSAGES IN QUEUE
════════════════════════════════════════════════════════════════════════════════

1. Go to: http://localhost:31672/#/queues

2. Click on "user.events" queue

3. Scroll to "Get messages from queue" section

4. Set "Ackmode" = "Ack message requeue false" (auto-delete after reading)

5. Click "Get Message(s)"

6. RESULT: You'll see the message you published!

7. Content should show:
   {
     "userId": 123,
     "action": "login",
     "timestamp": "2026-05-29T14:00:00Z",
     "source": "web"
   }

════════════════════════════════════════════════════════════════════════════════
TEST 3: TEST TOPIC ROUTING
════════════════════════════════════════════════════════════════════════════════

Goal: Publish to exchange with routing key, message goes to correct queue

Steps:

1. Go to: http://localhost:31672/#/exchanges

2. Click on "education.events" exchange

3. Scroll to "Publish message" section

4. Fill in:
   Routing key: activity.quiz_submitted
   Payload: 
   {
     "studentId": 456,
     "quizId": 789,
     "score": 95,
     "timestamp": "2026-05-29T14:05:00Z"
   }

5. Click "Publish message"

6. Expected: Message should be routed to "activity.logs" queue
   (Because "activity.*" matches routing key "activity.quiz_submitted")

7. Verify:
   a. Go to: http://localhost:31672/#/queues
   b. Click "activity.logs"
   c. Get message
   d. Should show the quiz message!

════════════════════════════════════════════════════════════════════════════════
TEST 4: TEST DIRECT ROUTING
════════════════════════════════════════════════════════════════════════════════

Goal: Send message only to specific queue via direct exchange

Steps:

1. Go to: http://localhost:31672/#/exchanges

2. Click on "education.direct" exchange

3. Publish message section:
   Routing key: classroom
   Payload:
   {
     "classroomId": 101,
     "message": "Tomorrow's class is cancelled",
     "teacher": "Mrs. Smith",
     "timestamp": "2026-05-29T14:10:00Z"
   }

4. Click "Publish message"

5. Expected: Message goes ONLY to "classroom.notifications" queue
   (Direct routing - exact match only)

6. Verify:
   a. Go to Queues
   b. Check "classroom.notifications" has the message
   c. Check other queues DON'T have it

════════════════════════════════════════════════════════════════════════════════
TEST 5: MONITORING & QUEUE STATS
════════════════════════════════════════════════════════════════════════════════

Current Status Check:

1. Go to: http://localhost:31672

2. View "Queues" page

3. For each queue, note:

   COLUMN               MEANING
   ─────────────────────────────────
   Ready        = Messages waiting to be consumed
   Unacked      = Messages being processed by consumer
   Total        = Ready + Unacked
   Idle         = Time since last activity
   Features     = D (durable), x (expires), etc.

4. Ideal state:
   ├─ user.events: 0 Ready, 0 Unacked
   ├─ activity.logs: 0 Ready, 0 Unacked  
   ├─ classroom.notifications: 0 Ready, 0 Unacked
   ├─ payment.transactions: 0 Ready, 0 Unacked
   └─ email.queue: 0 Ready, 0 Unacked

   (Means all messages are being consumed immediately)

════════════════════════════════════════════════════════════════════════════════
TEST 6: PURGE QUEUE (Delete all messages)
════════════════════════════════════════════════════════════════════════════════

If you want to clear a queue:

1. Go to: http://localhost:31672/#/queues

2. Click on queue name (e.g., "user.events")

3. Scroll down

4. Click red "Purge" button

5. Confirm deletion

6. RESULT: All messages in queue deleted

⚠️ WARNING: This is irreversible!

════════════════════════════════════════════════════════════════════════════════
EXPECTED RESULTS SUMMARY
════════════════════════════════════════════════════════════════════════════════

✅ TEST 1 (Publish to queue):
   After publishing: "user.events" queue shows 1 message

✅ TEST 2 (View message):
   Can read the JSON payload you published

✅ TEST 3 (Topic routing):
   "activity.logs" receives message with routing key "activity.*"

✅ TEST 4 (Direct routing):
   "classroom.notifications" receives direct message
   Other queues DON'T receive it

✅ TEST 5 (Monitoring):
   Can see queue stats and message counts

✅ TEST 6 (Purge):
   Queue becomes empty after purging

════════════════════════════════════════════════════════════════════════════════
TROUBLESHOOTING
════════════════════════════════════════════════════════════════════════════════

Problem: Can't login to Management UI
─────────────────────────────────────
Solution:
  1. Check URL: http://localhost:31672
  2. Credentials: guest / guest (case-sensitive)
  3. Check RabbitMQ pod: kubectl get pods -n message-queue
  4. Check port forwarding: kubectl get svc -n message-queue

Problem: No queues/exchanges visible
──────────────────────────────────────
Solution:
  1. Refresh browser (F5)
  2. Go to Admin > Users & Permissions
  3. Click "guest" user
  4. Ensure "administrator" tag is set
  5. Or run configuration script again

Problem: Message doesn't appear in queue after publishing
──────────────────────────────────────────────────────────
Solution:
  1. Check routing key matches binding
  2. Verify exchange type (topic vs direct)
  3. Check if queue is bound to exchange
  4. Try publishing directly to queue (not exchange)
  5. Check message format is valid JSON

Problem: Can't get message from queue
──────────────────────────────────────
Solution:
  1. Verify queue has messages (Check "Ready" count)
  2. Set Ackmode to "Ack message requeue false"
  3. Try different ack modes:
     • Nack requeue true = message goes back to queue
     • Ack requeue true = message stays if processing fails
  4. Check queue isn't in "exclusive" mode

════════════════════════════════════════════════════════════════════════════════
NEXT STEPS AFTER TESTING
════════════════════════════════════════════════════════════════════════════════

1. ✅ Verify configuration in Management UI
2. ✅ Run the 5 tests above
3. ✅ Confirm all queues and exchanges exist
4. → Connect your microservices to RabbitMQ
5. → Start publishing real events
6. → Monitor queue depths
7. → Set up alerts for high queue backlog

════════════════════════════════════════════════════════════════════════════════
