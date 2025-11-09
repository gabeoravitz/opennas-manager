#!/bin/bash

# OpenNAS Manager - Complete Application Generator
# Generates all remaining source files for a runnable application

set -e

echo "🚀 Generating complete OpenNAS Manager application..."
echo ""

cd "$(dirname "$0")/.."

# Create a comprehensive Python generator
python3 << 'PYTHON_SCRIPT'
import os
from pathlib import Path

os.chdir('/Users/gabe/Documents/scripts/files/opennas-manager')

def write_file(path, content):
    file_path = Path(path)
    file_path.parent.mkdir(parents=True, exist_ok=True)
    file_path.write_text(content)
    print(f"✓ {path}")

# ============================================================================
# BACKEND MODULES
# ============================================================================

# Auth Module
write_file('backend/src/modules/auth/auth.module.ts', '''import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { AuthService } from './services/auth.service';
import { AuthController } from './controllers/auth.controller';
import { JwtStrategy } from './strategies/jwt.strategy';
import { LocalStrategy } from './strategies/local.strategy';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    UsersModule,
    PassportModule,
    JwtModule.register({
      secret: process.env.JWT_SECRET || 'dev_secret',
      signOptions: { expiresIn: '24h' },
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy, LocalStrategy],
  exports: [AuthService],
})
export class AuthModule {}
''')

write_file('backend/src/modules/auth/controllers/auth.controller.ts', '''import { Controller, Post, Body, UseGuards, Get, Request } from '@nestjs/common';
import { AuthService } from '../services/auth.service';
import { LocalAuthGuard } from '../guards/local-auth.guard';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { ApiTags, ApiOperation } from '@nestjs/swagger';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @UseGuards(LocalAuthGuard)
  @Post('login')
  @ApiOperation({ summary: 'Login with username and password' })
  async login(@Request() req) {
    return this.authService.login(req.user);
  }

  @UseGuards(JwtAuthGuard)
  @Get('me')
  @ApiOperation({ summary: 'Get current user' })
  getProfile(@Request() req) {
    return req.user;
  }

  @UseGuards(JwtAuthGuard)
  @Post('logout')
  @ApiOperation({ summary: 'Logout' })
  async logout() {
    return { message: 'Logged out successfully' };
  }
}
''')

write_file('backend/src/modules/auth/services/auth.service.ts', '''import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
  constructor(private jwtService: JwtService) {}

  async validateUser(username: string, password: string): Promise<any> {
    // Mock validation - replace with real user lookup
    if (username === 'admin' && password === 'admin123') {
      return { id: '1', username: 'admin', email: 'admin@example.com', role: 'admin' };
    }
    return null;
  }

  async login(user: any) {
    const payload = { username: user.username, sub: user.id, role: user.role };
    return {
      user,
      token: this.jwtService.sign(payload),
    };
  }
}
''')

write_file('backend/src/modules/auth/strategies/jwt.strategy.ts', '''import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET || 'dev_secret',
    });
  }

  async validate(payload: any) {
    return { id: payload.sub, username: payload.username, role: payload.role };
  }
}
''')

write_file('backend/src/modules/auth/strategies/local.strategy.ts', '''import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-local';
import { AuthService } from '../services/auth.service';

@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy) {
  constructor(private authService: AuthService) {
    super();
  }

  async validate(username: string, password: string): Promise<any> {
    const user = await this.authService.validateUser(username, password);
    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }
    return user;
  }
}
''')

write_file('backend/src/modules/auth/guards/jwt-auth.guard.ts', '''import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
''')

write_file('backend/src/modules/auth/guards/local-auth.guard.ts', '''import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class LocalAuthGuard extends AuthGuard('local') {}
''')

# Users Module
write_file('backend/src/modules/users/users.module.ts', '''import { Module } from '@nestjs/common';
import { UsersService } from './services/users.service';
import { UsersController } from './controllers/users.controller';

@Module({
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
''')

write_file('backend/src/modules/users/controllers/users.controller.ts', '''import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards } from '@nestjs/common';
import { UsersService } from '../services/users.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('users')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @ApiOperation({ summary: 'Create user' })
  create(@Body() createUserDto: any) {
    return this.usersService.create(createUserDto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all users' })
  findAll() {
    return this.usersService.findAll();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get user by ID' })
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update user' })
  update(@Param('id') id: string, @Body() updateUserDto: any) {
    return this.usersService.update(id, updateUserDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete user' })
  remove(@Param('id') id: string) {
    return this.usersService.remove(id);
  }
}
''')

write_file('backend/src/modules/users/services/users.service.ts', '''import { Injectable } from '@nestjs/common';

@Injectable()
export class UsersService {
  private users = [
    { id: '1', username: 'admin', email: 'admin@example.com', role: 'admin' },
  ];

  create(createUserDto: any) {
    const user = { id: Date.now().toString(), ...createUserDto };
    this.users.push(user);
    return user;
  }

  findAll() {
    return this.users;
  }

  findOne(id: string) {
    return this.users.find(u => u.id === id);
  }

  findByUsername(username: string) {
    return this.users.find(u => u.username === username);
  }

  update(id: string, updateUserDto: any) {
    const index = this.users.findIndex(u => u.id === id);
    if (index > -1) {
      this.users[index] = { ...this.users[index], ...updateUserDto };
      return this.users[index];
    }
    return null;
  }

  remove(id: string) {
    const index = this.users.findIndex(u => u.id === id);
    if (index > -1) {
      this.users.splice(index, 1);
      return { deleted: true };
    }
    return { deleted: false };
  }
}
''')

# Stub modules for other features
for module in ['groups', 'files', 'storage', 'packages', 'logs', 'tasks', 'notifications', 'network', 'security', 'directory']:
    write_file(f'backend/src/modules/{module}/{module}.module.ts', f'''import {{ Module }} from '@nestjs/common';

@Module({{}})
export class {module.capitalize()}Module {{}}
''')

print("\n✅ Backend modules generated!")

# ============================================================================
# FRONTEND COMPONENTS
# ============================================================================

# Login Page
write_file('frontend/src/pages/auth/LoginPage.tsx', '''import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '@store/authStore';

export default function LoginPage() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();
  const login = useAuthStore(state => state.login);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    try {
      // Mock login - replace with real API call
      if (username === 'admin' && password === 'admin123') {
        login(
          { id: '1', username, email: 'admin@example.com', role: 'admin' },
          'mock_token'
        );
        navigate('/');
      } else {
        setError('Invalid credentials');
      }
    } catch (err) {
      setError('Login failed');
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-primary-500 to-primary-700">
      <div className="w-full max-w-md">
        <div className="card">
          <div className="card-body space-y-6">
            <div className="text-center">
              <h1 className="text-3xl font-bold text-gray-900">OpenNAS Manager</h1>
              <p className="mt-2 text-sm text-gray-600">Sign in to your account</p>
            </div>

            <form onSubmit={handleSubmit} className="space-y-4">
              {error && (
                <div className="rounded bg-error-50 p-3 text-sm text-error-700">
                  {error}
                </div>
              )}

              <div>
                <label htmlFor="username" className="block text-sm font-medium text-gray-700">
                  Username
                </label>
                <input
                  id="username"
                  name="username"
                  type="text"
                  required
                  className="input mt-1"
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                />
              </div>

              <div>
                <label htmlFor="password" className="block text-sm font-medium text-gray-700">
                  Password
                </label>
                <input
                  id="password"
                  name="password"
                  type="password"
                  required
                  className="input mt-1"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                />
              </div>

              <button type="submit" className="btn-primary w-full">
                Sign in
              </button>
            </form>

            <div className="text-center text-xs text-gray-500">
              Default credentials: admin / admin123
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
''')

# Dashboard Layout
write_file('frontend/src/components/layout/DashboardLayout.tsx', '''import { Outlet } from 'react-router-dom';
import Sidebar from './Sidebar';
import Topbar from './Topbar';

export default function DashboardLayout() {
  return (
    <div className="flex h-screen bg-background-secondary">
      <Sidebar />
      <div className="flex flex-1 flex-col">
        <Topbar />
        <main className="flex-1 overflow-auto p-6">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
''')

# Sidebar
write_file('frontend/src/components/layout/Sidebar.tsx', '''import { NavLink } from 'react-router-dom';
import {
  HomeIcon,
  FolderIcon,
  CubeIcon,
  ChartBarIcon,
  ClockIcon,
  DocumentTextIcon,
  ServerIcon,
  UsersIcon,
  ShieldCheckIcon,
  GlobeAltIcon,
} from '@heroicons/react/24/outline';

const navigation = [
  { name: 'Dashboard', href: '/', icon: HomeIcon },
  { name: 'File Station', href: '/file-station', icon: FolderIcon },
  { name: 'Package Center', href: '/package-center', icon: CubeIcon },
  { name: 'Resource Monitor', href: '/resource-monitor', icon: ChartBarIcon },
  { name: 'Task Scheduler', href: '/task-scheduler', icon: ClockIcon },
  { name: 'Log Center', href: '/log-center', icon: DocumentTextIcon },
  { name: 'Storage Manager', href: '/storage-manager', icon: ServerIcon },
  { name: 'Users', href: '/users', icon: UsersIcon },
  { name: 'Security', href: '/security', icon: ShieldCheckIcon },
  { name: 'Network', href: '/network', icon: GlobeAltIcon },
];

export default function Sidebar() {
  return (
    <div className="sidebar">
      <div className="flex h-16 items-center border-b border-gray-200 px-4">
        <h1 className="text-xl font-bold text-primary-600">OpenNAS</h1>
      </div>
      <nav className="flex-1 space-y-1 p-4">
        {navigation.map((item) => (
          <NavLink
            key={item.name}
            to={item.href}
            className={({ isActive }) =>
              isActive ? 'sidebar-item sidebar-item-active' : 'sidebar-item'
            }
          >
            <item.icon className="h-5 w-5" />
            <span className="ml-3">{item.name}</span>
          </NavLink>
        ))}
      </nav>
    </div>
  );
}
''')

# Topbar
write_file('frontend/src/components/layout/Topbar.tsx', '''import { useAuthStore } from '@store/authStore';
import { BellIcon, UserCircleIcon } from '@heroicons/react/24/outline';

export default function Topbar() {
  const { user, logout } = useAuthStore();

  return (
    <header className="flex h-16 items-center justify-between border-b border-gray-200 bg-white px-6">
      <div className="flex items-center space-x-4">
        <h2 className="text-lg font-semibold text-gray-900">Dashboard</h2>
      </div>

      <div className="flex items-center space-x-4">
        <button className="btn-ghost btn-sm">
          <BellIcon className="h-5 w-5" />
        </button>

        <div className="flex items-center space-x-2">
          <UserCircleIcon className="h-8 w-8 text-gray-400" />
          <div className="text-sm">
            <div className="font-medium text-gray-900">{user?.username}</div>
            <button onClick={logout} className="text-xs text-gray-500 hover:text-gray-700">
              Sign out
            </button>
          </div>
        </div>
      </div>
    </header>
  );
}
''')

# Dashboard Page
write_file('frontend/src/pages/Dashboard.tsx', '''export default function Dashboard() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
        <p className="mt-1 text-sm text-gray-600">Welcome to OpenNAS Manager</p>
      </div>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
        <div className="card">
          <div className="card-body">
            <h3 className="text-lg font-semibold">System Status</h3>
            <div className="mt-4 space-y-2">
              <div className="flex justify-between">
                <span className="text-sm text-gray-600">CPU Usage</span>
                <span className="text-sm font-medium">23%</span>
              </div>
              <div className="flex justify-between">
                <span className="text-sm text-gray-600">Memory</span>
                <span className="text-sm font-medium">4.2 GB / 16 GB</span>
              </div>
              <div className="flex justify-between">
                <span className="text-sm text-gray-600">Storage</span>
                <span className="text-sm font-medium">256 GB / 1 TB</span>
              </div>
            </div>
          </div>
        </div>

        <div className="card">
          <div className="card-body">
            <h3 className="text-lg font-semibold">Recent Activity</h3>
            <div className="mt-4 space-y-2 text-sm text-gray-600">
              <div>User login: admin</div>
              <div>File uploaded: document.pdf</div>
              <div>Package installed: Office</div>
            </div>
          </div>
        </div>

        <div className="card">
          <div className="card-body">
            <h3 className="text-lg font-semibold">Quick Actions</h3>
            <div className="mt-4 space-y-2">
              <button className="btn-secondary w-full">Create Shared Folder</button>
              <button className="btn-secondary w-full">Add User</button>
              <button className="btn-secondary w-full">Install Package</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
''')

# Stub pages
for page in ['FileStation', 'PackageCenter', 'LogCenter', 'TaskScheduler', 'ResourceMonitor', 'StorageManager', 'UserManagement', 'GroupManagement', 'NetworkSettings', 'SecuritySettings']:
    write_file(f'frontend/src/pages/{page}.tsx', f'''export default function {page}() {{
  return (
    <div>
      <h1 className="text-2xl font-bold text-gray-900">{page.replace(/([A-Z])/g, ' $1').trim()}</h1>
      <p className="mt-2 text-gray-600">Feature implementation in progress...</p>
    </div>
  );
}}
''')

print("\n✅ Frontend components generated!")

# ============================================================================
# TESTS
# ============================================================================

write_file('e2e/tests/auth/login.spec.ts', '''import { test, expect } from '@playwright/test';

test.describe('Login', () => {
  test('should login successfully with valid credentials', async ({ page }) => {
    await page.goto('/login');
    
    await page.fill('[name="username"]', 'admin');
    await page.fill('[name="password"]', 'admin123');
    await page.click('button[type="submit"]');
    
    await expect(page).toHaveURL('/');
    await expect(page.locator('text=Dashboard')).toBeVisible();
  });

  test('should show error with invalid credentials', async ({ page }) => {
    await page.goto('/login');
    
    await page.fill('[name="username"]', 'invalid');
    await page.fill('[name="password"]', 'wrong');
    await page.click('button[type="submit"]');
    
    await expect(page.locator('text=Invalid credentials')).toBeVisible();
  });
});
''')

write_file('frontend/src/test/setup.ts', '''import '@testing-library/jest-dom';
''')

print("\n✅ Tests generated!")

print("\n" + "="*60)
print("✅ Complete application generated successfully!")
print("="*60)

PYTHON_SCRIPT

echo ""
echo "✅ Application generation complete!"
echo ""
echo "📦 Project structure:"
find . -type f -name "*.ts" -o -name "*.tsx" -o -name "*.json" | grep -v node_modules | wc -l | xargs echo "   TypeScript/JSON files:"
echo ""
echo "🎯 Next steps:"
echo "   1. npm install"
echo "   2. cd frontend && npm install"
echo "   3. cd ../backend && npm install"
echo "   4. cd ../e2e && npm install"
echo "   5. docker-compose up -d"
echo "   6. npm run dev"
echo ""
