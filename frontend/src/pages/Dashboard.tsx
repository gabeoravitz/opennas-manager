export default function Dashboard() {
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
