// ── Autenticação ─────────────────────────────────────────────
export type UserRole =
  | 'MASTER'
  | 'ADMIN_EMPRESA'
  | 'GESTOR_SST'
  | 'TECNICO_SST'
  | 'USUARIO'
  | 'AUDITOR';

export interface User {
  id: string;
  company_id: string;
  nome: string;
  email: string;
  telefone?: string;
  cargo?: string;
  avatar_url?: string;
  role: UserRole;
  status: 'ATIVO' | 'BLOQUEADO' | 'INATIVO';
  ultimo_acesso?: string;
}

export interface Session {
  user: User;
  access_token: string;
  refresh_token: string;
  expires_at: number;
}

// ── Empresa ───────────────────────────────────────────────────
export type PlanType = 'STARTER' | 'PROFESSIONAL' | 'ENTERPRISE' | 'CORPORATE';
export type CompanyStatus = 'ATIVO' | 'TRIAL' | 'SUSPENSO' | 'BLOQUEADO';

export interface Company {
  id: string;
  nome: string;
  cnpj?: string;
  logo_url?: string;
  segmento?: string;
  status: CompanyStatus;
}

export interface Subscription {
  id: string;
  company_id: string;
  plano: PlanType;
  status: 'TRIAL' | 'ATIVO' | 'INADIMPLENTE' | 'CANCELADO';
  limite_usuarios: number;
  limite_relatos: number;
  expiracao?:
cat > src/stores/authStore.ts << 'EOF'
import { create } from 'zustand';
import type { User, Session } from '@/types';

interface AuthState {
  user: User | null;
  session: Session | null;
  isLoading: boolean;
  isAuthenticated: boolean;
  setUser: (user: User | null) => void;
  setSession: (session: Session | null) => void;
  setLoading: (v: boolean) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user:            null,
  session:         null,
  isLoading:       true,
  isAuthenticated: false,
  setUser:    (user)      => set({ user, isAuthenticated: !!user }),
  setSession: (session)   => set({ session, isAuthenticated: !!session }),
  setLoading: (isLoading) => set({ isLoading }),
  logout: () => set({ user: null, session: null, isAuthenticated: false }),
}));
