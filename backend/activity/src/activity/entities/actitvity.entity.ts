import { Entity, Column, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import { Classroom } from '../../shared/entities/classroom.entity';

@Entity()
export class Activity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column()
  type: string;

  @Column({ nullable: true })
  description: string;

  @Column({ nullable: true })
  location: string;

  @Column()
  date: Date;

  @Column()
  duration: number;

  @Column({ default: false })
  isCompleted: boolean;

  @Column()
  classroomId: number;

  @ManyToOne(() => Classroom, classroom => classroom.activities)
  classroom: Classroom;
}
