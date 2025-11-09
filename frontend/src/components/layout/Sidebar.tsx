import { NavLink } from 'react-router-dom';
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
