import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { UserService } from '../service/user.service';
import { CreateUserDto } from '../dto/create-user.dto';
import { UpdateUserDto } from '../dto/update-user.dto';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  // Health check - MUST BE BEFORE :id
  @Get('health')
  healthCheck() {
    console.log('[GET /user/health]');
    return { status: 'ok' };
  }

  // Delete multiple - MUST BE BEFORE :id
  @Post('deleteMultipleUser')
  removeMultiple(@Body() tab: any) {
    console.log('[POST /user/deleteMultipleUser] Received:', tab);
    return this.userService.removeMultiple(tab);
  }

  // Find by email - MUST BE BEFORE :id
  @Get('email/:email')
  findByEmail(@Param('email') email: string) {
    console.log('[GET /user/email/:email] Email:', email);
    return this.userService.findOne(email);
  }

  // Create user
  @Post()
  async createUser(@Body() userDto: CreateUserDto) {
    console.log('[POST /user] Received:', userDto);
    try {
      const result = await this.userService.createUser(userDto);
      console.log('[POST /user] ✅ Created:', result);
      return result;
    } catch (error) {
      console.error('[POST /user] ❌ Error:', error);
      throw error;
    }
  }

  // Get all users
  @Get()
  find(): any {
    console.log('[GET /user]');
    return this.userService.findUsers();
  }

  // Update user by ID - AFTER specific routes
  @Patch(':id')
  async replaceById(@Param('id') id: number, @Body() userDto: UpdateUserDto) {
    console.log('[PATCH /user/:id] ID:', id, 'Data:', userDto);
    return this.userService.replaceById(id, userDto);
  }

  // Get user by ID - AFTER specific routes
  @Get(':id')
  findById(@Param('id') id: number) {
    console.log('[GET /user/:id] ID:', id);
    return this.userService.findById(id);
  }

  // Delete user by ID - AFTER specific routes
  @Delete(':id')
  remove(@Param('id') id: number) {
    console.log('[DELETE /user/:id] ID:', id);
    return this.userService.remove(id);
  }
}
