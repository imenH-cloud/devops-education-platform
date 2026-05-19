export class CreateActivityDto {
  name: string;
  type: string;
  description?: string;
  location?: string;
  date: string;
  duration: number;
  isCompleted?: boolean;
  classroomId: number;
}
