import { useAuthStore } from '@store/authStore';
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
