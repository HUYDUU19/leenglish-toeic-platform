/**
 * ================================================================
 * PROFILE PAGE COMPONENT
 * ================================================================
 */

import React from 'react';

const ProfilePage: React.FC = () => {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Profile</h1>
        <p className="mt-2 text-gray-600">Manage your account information</p>
      </div>

      <div className="card">
        <div className="card-header">
          <h2 className="text-xl font-semibold text-gray-900">Personal Information</h2>
        </div>
        <div className="card-body">
          <p className="text-gray-600">Profile management coming soon.</p>
        </div>
      </div>
    </div>
  );
};

export default ProfilePage;
