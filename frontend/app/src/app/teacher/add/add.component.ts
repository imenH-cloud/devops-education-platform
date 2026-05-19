import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { TeacherService } from '../teacher.service';

@Component({
  selector: 'app-add',
  standalone: false,
  templateUrl: './add.component.html',
  styleUrl: './add.component.css'
})
export class AddComponent {
 teacherForm: FormGroup;
  submitted = false;
  loading = false;

  constructor(
    private fb: FormBuilder,
    private teacherService: TeacherService,
    private router: Router
  ) {
    this.teacherForm = this.fb.group({
      indexNumber: ['', Validators.required],
      cin: ['', Validators.required],
      firstName: ['', [Validators.required, Validators.minLength(2)]],
      surname: ['', [Validators.required, Validators.minLength(2)]],
      gender: ['', Validators.required],
      address: ['', Validators.required],
      telephone: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, Validators.minLength(6)]],
      facebook: [''],
      instagram: [''],
      linkedin: [''],
      specialization: ['', Validators.required],
      profileImage: [''],
      dateOfMandate: ['', Validators.required]
    });
  }

  ngOnInit(): void {}

  get f() {
    return this.teacherForm.controls;
  }

  onSubmit(): void {
    this.submitted = true;
    if (this.teacherForm.invalid) {
      console.log('Form invalid:', this.teacherForm.errors);
      return;
    }

    const teacherData = this.teacherForm.value;
    console.log('Submitting teacher:', teacherData);

    this.teacherService.create(teacherData).subscribe({
      next: (res:any) => {
        console.log('Teacher created:', res);
        this.router.navigate(['/teacher']);
      },
      error: (err:any) => {
        console.error('Error creating teacher:', err);
        alert('Une erreur est survenue. Veuillez réessayer.');
      }
    });
  }

  goBack(): void {
    this.router.navigate(['/teacher']);
  }
}
