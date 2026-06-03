import { Component, OnInit } from '@angular/core';
import { UserService } from '../user.service';
import { Router } from '@angular/router';
import { User } from '../user';

@Component({
  selector: 'app-user-list',
  templateUrl: './user-list.component.html',
  styleUrl: './user-list.component.css',
  standalone: false
})
export class ListUserComponent implements OnInit {
  users: User[] = [];
  filteredUsers: User[] = [];
  selectedUsers: number[] = [];
  searchTerm = '';
  statusFilter = '';
  loading = false;

  constructor(
    private userService: UserService,
    private router: Router
  ) {}

  ngOnInit(): void {
    console.log('✅ ListUserComponent initialized');
    this.loadUsers();
  }

  loadUsers(): void {
    console.log('📡 Loading users...');
    this.loading = true;
    this.userService.getUsers().subscribe({
      next: (users: any) => {
        console.log('✅ Users loaded:', users);
        this.users = Array.isArray(users) ? users : [];
        this.filteredUsers = this.users;
        this.loading = false;
      },
      error: (error) => {
        console.error('❌ Error loading users:', error);
        this.users = [];
        this.filteredUsers = [];
        this.loading = false;
      }
    });
  }

  filterUsers(): void {
    this.filteredUsers = this.users.filter(user => {
      const matchesSearch = !this.searchTerm || 
        user.firstName?.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
        user.lastName?.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
        user.email?.toLowerCase().includes(this.searchTerm.toLowerCase());
      
      const matchesStatus = !this.statusFilter || 
        user.active.toString() === this.statusFilter;

      return matchesSearch && matchesStatus;
    });
  }

  toggleSelectAll(event: any): void {
    if (event.target.checked) {
      this.selectedUsers = this.filteredUsers.map(user => user.id);
    } else {
      this.selectedUsers = [];
    }
  }

  toggleUserSelection(userId: number, event: any): void {
    if (event.target.checked) {
      this.selectedUsers.push(userId);
    } else {
      this.selectedUsers = this.selectedUsers.filter(id => id !== userId);
    }
  }

  navigateToAdd(): void {
    console.log('📍 Navigating to add user');
    this.router.navigate(['/user', 'add-user']);
  }

  navigateToEdit(id: number): void {
    console.log('📍 Navigating to edit user:', id);
    this.router.navigate(['/user', 'update-user', id]);
  }

  deleteUser(id: number): void {
    if (confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?')) {
      console.log('🗑️ Deleting user:', id);
      this.userService.deleteUser(id).subscribe({
        next: () => {
          console.log('✅ User deleted successfully');
          this.loadUsers();
        },
        error: (error) => {
          console.error('❌ Error deleting user:', error);
        }
      });
    }
  }

  deleteSelected(): void {
    if (confirm(`Êtes-vous sûr de vouloir supprimer ${this.selectedUsers.length} utilisateurs sélectionnés ?`)) {
      console.log('🗑️ Deleting multiple users:', this.selectedUsers);
      this.userService.deleteMultipleUsers(this.selectedUsers).subscribe({
        next: () => {
          console.log('✅ Users deleted successfully');
          this.selectedUsers = [];
          this.loadUsers();
        },
        error: (error) => {
          console.error('❌ Error deleting users:', error);
        }
      });
    }
  }
}
