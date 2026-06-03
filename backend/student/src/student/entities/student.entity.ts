import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Classroom } from '../shared/entities/classroom.entity';
import { Parent } from '../shared/entities/parent.entity';

@Entity('student')
export class Student {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'firstname' })
  firstName: string;

  @Column({ name: 'lastname' })
  lastName: string;

  @Column({ name: 'email', unique: true })
  email: string;

  @Column({ name: 'dateofbirth', type: 'date', nullable: true })
  dateOfBirth: Date;

  @Column({ name: 'phonenumber', nullable: true })
  phoneNumber: string;

  @Column({ name: 'enrollmentdate', type: 'date', nullable: true })
  enrollmentDate: Date;

  @Column({ name: 'observations', type: 'text', nullable: true })
  observations: string;

  @Column({ name: 'medicalreports', type: 'text', nullable: true })
  medicalReports: string;

  @Column({ name: 'isactive', default: true })
  isActive: boolean;

  @ManyToOne(() => Parent, (parent) => parent.students, { nullable: true })
  @JoinColumn({ name: 'parentid' })
  parent: Parent;

  @ManyToOne(() => Classroom, (classroom) => classroom.students, { nullable: true })
  @JoinColumn({ name: 'classroomid' })
  classroom: Classroom;
}
