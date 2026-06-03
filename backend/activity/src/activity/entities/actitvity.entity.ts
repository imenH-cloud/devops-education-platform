import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Classroom } from '../../shared/entities/classroom.entity';

@Entity()
export class Activity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ nullable: true })
  name: string;

  @Column({ nullable: true })
  type: string;

  @Column({ nullable: true })
  description: string;

  @Column({ nullable: true })
  location: string;

  @Column({ nullable: true })
  date: Date;

  @Column({ nullable: true })
  duration: number;

  @Column({ name: 'iscompleted', default: false, nullable: true })
  isCompleted: boolean;

  @Column({ name: 'classroomid', nullable: true })
  classroomId: number;

  @Column({ type: 'simple-json', nullable: true })
  metadata: {
    resources?: string[];
    attachments?: string[];
    comments?: string;
  };

  @ManyToOne(() => Classroom, classroom => classroom.activities, { nullable: true })
  @JoinColumn({ name: 'classroomid' })
  classroom: Classroom;
}
