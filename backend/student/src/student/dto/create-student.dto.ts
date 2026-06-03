import { IsString, IsNumber, IsNotEmpty, IsOptional, IsBoolean, IsDate, IsEmail, IsArray } from 'class-validator';

export class CreateStudentDto {
    @IsNotEmpty()
    @IsString()
    firstName: string;

    @IsNotEmpty()
    @IsString()
    numeroInscriptio: string;

    @IsNotEmpty()
    @IsString()
    lastName: string;

    @IsNotEmpty()
    @IsEmail()
    email: string;

    @IsNotEmpty()
    @IsDate()
    dateOfBirth: Date;

    @IsNotEmpty()
    @IsString()
    phoneNumber: string;

    @IsNotEmpty()
    @IsString()
    address: string;

    @IsOptional()
    @IsBoolean()
    isActive?: boolean;

    @IsNotEmpty()
    @IsDate()
    enrollmentDate: Date;

    @IsOptional()
    @IsString()
    observations?: string;

    @IsOptional()
    @IsArray()
    interventionReports?: Record<string, any>[];

    @IsOptional()
    @IsNumber()
    parentId?: number;

    @IsOptional()
    @IsNumber()
    classroomId?: number;
}
