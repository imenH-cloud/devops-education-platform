import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { UserService } from '../user.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-user-add',
  templateUrl: './user-add.component.html',
  styleUrl: './user-add.component.css',
  standalone: false
})
export class UserADDComponent implements OnInit {
  userForm: FormGroup;
  submitted = false;
  loading = false;
  showSuccess = false;
  showError = false;
  errorMessage = '';
  successMessage = '';

  constructor(
    private fb: FormBuilder,
    private userService: UserService,
    private router: Router
  ) {
    this.userForm = this.fb.group({
      firstName: ['', [Validators.required]],
      lastName: ['', [Validators.required]],
      email: ['', [Validators.required, Validators.email]],
      phone: [''],
      address: [''],
      zipCode: [''],
      picture: [''],
      password: ['', [Validators.required, Validators.minLength(6)]],
      active: [true]
    });
  }

  ngOnInit(): void {
    console.log('✅ User Add Component initialized');
  }

  onImageError($event: ErrorEvent) {
    console.error('Image load error:', $event);
  }

  onSubmit(): void {
    this.submitted = true;
    console.log('✅ Form submitted');
    console.log('Form status:', this.userForm.status);
    console.log('Form value:', this.userForm.value);

    if (this.userForm.invalid) {
      console.error('❌ Form invalid');
      this.showError = true;
      this.errorMessage = 'Veuillez remplir tous les champs correctement';
      return;
    }

    this.loading = true;
    this.showError = false;
    this.showSuccess = false;

    console.log('📡 Creating user:', this.userForm.value);

    this.userService.createUser(this.userForm.value).subscribe({
      next: (response: any) => {
        console.log('✅ User created successfully:', response);
        this.loading = false;
        this.showSuccess = true;
        this.successMessage = 'Utilisateur ajouté avec succès !';
        
        // Redirect after 2 seconds
        setTimeout(() => {
          this.router.navigate(['/user']);
        }, 2000);
      },
      error: (error: any) => {
        console.error('❌ Error creating user:', error);
        this.loading = false;
        this.showError = true;
        this.errorMessage = error?.error?.message || 'Erreur lors de la création de l\'utilisateur';
      }
    });
  }

  goBack(): void {
    this.router.navigate(['/user']);
  }

  get f() {
    return this.userForm.controls;
  }
}
