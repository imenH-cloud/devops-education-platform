export class CreateClassroomDto {
    name: string;
    capacity: number;
    grade: string;
    academicYear: string;
    description?: string;
    isActive?: boolean;
    location?: string;
    Specialization?: string;
}
