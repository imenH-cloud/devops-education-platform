import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Student } from '../entities/student.entity';
import { CreateStudentDto } from '../dto/create-student.dto';
import { UpdateStudentDto } from '../dto/update-student.dto';

@Injectable()
export class StudentService {
  constructor(
    @InjectRepository(Student)
    private readonly studentRepository: Repository<Student>,
  ) {}

  async create(createStudentDto: CreateStudentDto): Promise<Student> {
    try {
      console.log('[StudentService.create] Input:', createStudentDto);

      // Build data object - only BD columns
      const data = {
        firstName: createStudentDto.firstName,
        lastName: createStudentDto.lastName,
        email: createStudentDto.email,
        phoneNumber: createStudentDto.phoneNumber || null,
        dateOfBirth: createStudentDto.dateOfBirth || null,
        enrollmentDate: createStudentDto.enrollmentDate || null,
        observations: createStudentDto.observations || null,
        medicalReports: createStudentDto.medicalReports || null,
      } as any;

      if (createStudentDto.parentId) {
        data.parent = { id: createStudentDto.parentId };
      }
      if (createStudentDto.classroomId) {
        data.classroom = { id: createStudentDto.classroomId };
      }

      // Save directly - no create() call
      const result = await this.studentRepository.save(data);
      console.log('[StudentService.create] Success! ID:', result.id);
      return result;
    } catch (error) {
      console.error('[StudentService.create] Error:', error.message);
      throw new BadRequestException(`Failed to create student: ${error.message}`);
    }
  }

  async findAll(): Promise<Student[]> {
    return await this.studentRepository.find();
  }

  async findOne(id: number): Promise<Student> {
    const student = await this.studentRepository.findOne({ where: { id } });
    if (!student) {
      throw new NotFoundException(`Student with ID ${id} not found`);
    }
    return student;
  }

  async update(id: number, updateStudentDto: UpdateStudentDto): Promise<Student> {
    const student = await this.findOne(id);
    Object.assign(student, updateStudentDto);
    return await this.studentRepository.save(student);
  }

  async remove(id: number): Promise<void> {
    const result = await this.studentRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Student with ID ${id} not found`);
    }
  }

  async findByEmail(email: string): Promise<Student | null> {
    return await this.studentRepository.findOne({ where: { email } });
  }

  async findByStudentId(studentId: number): Promise<Student | null> {
    return await this.studentRepository.findOne({ where: { id: studentId } });
  }

  async findByClass(classId: number): Promise<Student[]> {
    return await this.studentRepository.find({
      where: { classroom: { id: classId } },
      order: { lastName: 'ASC', firstName: 'ASC' },
    });
  }

  async findWithCourses(id: number): Promise<Student> {
    const student = await this.studentRepository.findOne({
      where: { id },
      relations: ['enrollments', 'enrollments.course'],
    });

    if (!student) {
      throw new NotFoundException(`Student with ID ${id} not found`);
    }

    return student;
  }
}
