const bcrypt = require('bcrypt');

bcrypt.hash('admin12345', 10, (err, hash) => {
  if (err) {
    console.error('Error:', err);
    process.exit(1);
  }
  console.log('Hash for admin12345:', hash);
  
  // Verify it works
  bcrypt.compare('admin12345', hash, (err, result) => {
    console.log('Verification result:', result);
  });
});
