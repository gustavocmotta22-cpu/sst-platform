import { create } from 'zustand';
import type { SyncStatus } from '@/types';

interface SyncState {
  status: SyncStatus;
  pendingCount: number;
  lastSyncAt: string | null;
  errorMessage: string | null;
  setStatus:  (status: SyncStatus) => void;
  setPending: (count: number) => void;
  setSynced:  () => void;
  setError:   (msg: string) => void;
}

export const useSyncStore = create<SyncState>((set) => ({
  status:       'online',
  pendingCount: 0,
  lastSyncAt:   null,
  errorMessage: null,
  setStatus:  (status)       => set({ status, errorMessage: null }),
  setPending: (pendingCount) => set({ pendingCount }),
  setSynced:  () => set({ status: 'online', pendingCount: 0, lastSyncAt: new Date().toISOString(), errorMessage: null }),
  setError:   (errorMessage) => set({ status: 'error', errorMessage }),
}));
