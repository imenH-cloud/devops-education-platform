import { IsString, IsNotEmpty, IsOptional, IsISO8601, IsEmail } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateStudentDto {
    @IsNotEmpty()
    @IsString()
    firstName: string;

    @IsNotEmpty()
    @IsString()
    lastName: string;

    @IsNotEmpty()
    @IsEmail()
    email: string;

    @IsOptional()
    @IsISO8601()
    @Type(() => Date)
    dateOfBirth?: Date;

    @IsOptional()
    @IsString()
    phoneNumber?: string;

    @IsOptional()
    @IsISO8601()
    @Type(() => Date)
    enrollmentDate?: Date;

    @IsOptional()
    @IsString()
    observations?: string;

    @IsOptional()
    @IsString()
    medicalReports?: string;

    @IsOptional()
    parentId?: number;

    @IsOptional()
    classroomId?: number;
}
