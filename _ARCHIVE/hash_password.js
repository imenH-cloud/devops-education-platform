const bcrypt = require('bcryptjs');

// Generate bcrypt hash for 'admin12345'
bcrypt.hash('admin12345', 10, (err, hash) => {
  if (err) {
    console.error('Error:', err);
    process.exit(1);
  }
  console.log('Hashed password:', hash);
});
