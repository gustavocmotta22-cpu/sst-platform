#!/bin/bash
# SST Platform — Script de criação completa do sst-mobile
# Cole e execute no terminal do Codespace:
# chmod +x criar-sst-mobile.sh && bash criar-sst-mobile.sh

set -e
echo "=== SST Platform — Criando projeto mobile ==="

# Ir para raiz do workspace
cd /workspaces/sst-platform

# Remover pasta antiga se existir
rm -rf sst-mobile
mkdir -p sst-mobile
cd sst-mobile

echo "--- Criando package.json ---"
cat > package.json << 'PKGJSON'
{
  "name": "sst-mobile",
  "version": "1.0.0",
  "main": "expo-router/entry",
  "scripts": {
    "start": "expo start",
    "android": "expo start --android",
    "ios": "expo start --ios",
    "build:android": "eas build --platform android --profile preview",
    "build:android:prod": "eas build --platform android --profile production",
    "build:ios": "eas build --platform ios --profile preview",
    "build:ios:prod": "eas build --platform ios --profile production"
  },
  "dependencies": {
    "@expo/vector-icons": "^14.0.0",
    "@hookform/resolvers": "^3.3.4",
    "@react-native-async-storage/async-storage": "2.1.2",
    "@react-native-community/netinfo": "11.4.1",
    "@tanstack/react-query": "^5.28.0",
    "axios": "^1.6.7",
    "expo": "~52.0.0",
    "expo-camera": "~16.0.0",
    "expo-device": "~7.0.0",
    "expo-file-system": "~18.0.0",
    "expo-font": "~13.0.0",
    "expo-image-picker": "~16.0.0",
    "expo-location": "~18.0.0",
    "expo-notifications": "~0.29.0",
    "expo-router": "~4.0.0",
    "expo-secure-store": "~14.0.0",
    "expo-splash-screen": "~0.29.0",
    "expo-status-bar": "~2.0.0",
    "react": "18.3.2",
    "react-hook-form": "^7.51.0",
    "react-native": "0.76.7",
    "react-native-gesture-handler": "~2.20.0",
    "react-native-reanimated": "~3.16.0",
    "react-native-safe-area-context": "4.12.0",
    "react-native-screens": "~4.4.0",
    "react-native-signature-canvas": "^4.7.2",
    "react-native-svg": "15.8.0",
    "react-native-webview": "13.12.5",
    "uuid": "^9.0.0",
    "zod": "^3.22.4",
    "zustand": "^4.5.2"
  },
  "devDependencies": {
    "@babel/core": "^7.24.0",
    "@types/react": "~18.3.12",
    "@types/uuid": "^9.0.7",
    "typescript": "^5.3.3"
  }
}
PKGJSON

echo "--- Criando app.json ---"
cat > app.json << 'APPJSON'
{
  "expo": {
    "name": "SST Platform",
    "slug": "sst-platform",
    "version": "1.0.0",
    "orientation": "portrait",
    "userInterfaceStyle": "light",
    "assetBundlePatterns": ["**/*"],
    "ios": {
      "supportsTablet": true,
      "bundleIdentifier": "com.sst.mobile",
      "buildNumber": "1",
      "infoPlist": {
        "NSCameraUsageDescription": "Utilizado para capturar evidências fotográficas de ocorrências de segurança no trabalho.",
        "NSLocationWhenInUseUsageDescription": "Utilizado para registrar a localização exata do relato de segurança.",
        "NSPhotoLibraryUsageDescription": "Utilizado para anexar evidências fotográficas existentes ao relato.",
        "NSPhotoLibraryAddUsageDescription": "Utilizado para salvar evidências capturadas durante o registro da ocorrência.",
        "NSMicrophoneUsageDescription": "Utilizado para capturar vídeos de evidências com áudio.",
        "ITSAppUsesNonExemptEncryption": false
      }
    },
    "android": {
      "package": "com.sst.mobile",
      "versionCode": 1,
      "permissions": [
        "CAMERA",
        "READ_EXTERNAL_STORAGE",
        "WRITE_EXTERNAL_STORAGE",
        "ACCESS_FINE_LOCATION",
        "ACCESS_COARSE_LOCATION",
        "INTERNET",
        "ACCESS_NETWORK_STATE",
        "VIBRATE",
        "POST_NOTIFICATIONS"
      ]
    },
    "plugins": [
      "expo-router",
      "expo-font",
      ["expo-camera", {
        "cameraPermission": "O SST Platform precisa da câmera para registrar evidências de segurança.",
        "microphonePermission": "O SST Platform precisa do microfone para gravar vídeos de evidências.",
        "recordAudioAndroid": true
      }],
      ["expo-location", {
        "locationWhenInUsePermission": "O SST Platform usa sua localização para registrar o local exato do incidente.",
        "isAndroidBackgroundLocationEnabled": false
      }],
      ["expo-image-picker", {
        "photosPermission": "O SST Platform acessa suas fotos para anexar evidências ao relato.",
        "cameraPermission": "O SST Platform precisa da câmera para registrar evidências."
      }],
      ["expo-notifications", {
        "color": "#0F2D5E"
      }],
      "expo-secure-store"
    ],
    "scheme": "sst-platform",
    "extra": {
      "EXPO_PUBLIC_API_URL": "https://sst-backend.railway.app/api/v1",
      "eas": {
        "projectId": "c4cdef16-2390-4f4a-8f64-203358a75414"
      }
    }
  }
}
APPJSON

echo "--- Criando eas.json ---"
cat > eas.json << 'EASJSON'
{
  "cli": {
    "version": ">= 10.0.0"
  },
  "build": {
    "preview": {
      "distribution": "internal",
      "android": {
        "buildType": "apk"
      }
    },
    "production": {
      "autoIncrement": true,
      "android": {
        "buildType": "aab"
      }
    }
  }
}
EASJSON

echo "--- Criando babel.config.js ---"
cat > babel.config.js << 'BABEL'
module.exports = function (api) {
  api.cache(true);
  return {
    presets: ['babel-preset-expo'],
    plugins: ['react-native-reanimated/plugin'],
  };
};
BABEL

echo "--- Criando tsconfig.json ---"
cat > tsconfig.json << 'TSCONFIG'
{
  "extends": "expo/tsconfig.base",
  "compilerOptions": {
    "strict": true,
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
TSCONFIG

echo "--- Criando estrutura de pastas ---"
mkdir -p src/app/auth
mkdir -p src/app/relatos/\[id\]
mkdir -p src/components/ui
mkdir -p src/constants
mkdir -p src/hooks
mkdir -p src/repositories
mkdir -p src/services
mkdir -p src/stores
mkdir -p src/types
mkdir -p assets

echo "--- Criando assets placeholder ---"
# Asset placeholder mínimo para o build funcionar
python3 -c "
import base64
# PNG 1x1 azul (#0F2D5E)
png_b64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=='
data = base64.b64decode(png_b64)
for name in ['icon.png', 'splash.png', 'adaptive-icon.png', 'notification-icon.png']:
    with open(f'assets/{name}', 'wb') as f:
        f.write(data)
print('Assets criados')
"

echo "--- Criando src/types/index.ts ---"
cat > src/types/index.ts << 'TYPES'
export interface User {
  id: string;
  nome: string;
  email: string;
  role: UserRole;
  tenantId: string;
}

export type UserRole =
  | 'ADMIN_PLATAFORMA' | 'ADMIN_EMPRESA' | 'GESTOR_SST'
  | 'TECNICO_SST' | 'LIDER_EQUIPE' | 'COLABORADOR'
  | 'VISITANTE' | 'AUDITOR' | 'SUPORTE';

export type RelatoTipo =
  | 'INCIDENTE' | 'QUASE_ACIDENTE' | 'CONDICAO_INSEGURA'
  | 'ATO_INSEGURO' | 'SUGESTAO_MELHORIA' | 'OBSERVACAO_POSITIVA';

export type RelatoGravidade = 'BAIXA' | 'MEDIA' | 'ALTA' | 'CRITICA';

export type RelatoStatus =
  | 'RASCUNHO' | 'ENVIADO' | 'EM_ANALISE'
  | 'EM_TRATAMENTO' | 'CONCLUIDO' | 'CANCELADO';

export type SyncStatus = 'PENDENTE' | 'SINCRONIZADO' | 'ERRO';

export interface Relato {
  id: string;
  clientId: string;
  tenantId: string;
  autorId: string;
  titulo: string;
  descricao: string;
  tipo: RelatoTipo;
  gravidade: RelatoGravidade;
  status: RelatoStatus;
  localDescricao?: string;
  latitude?: number;
  longitude?: number;
  precisaoGps?: number;
  dataOcorrencia: string;
  empresaId?: string;
  setorId?: string;
  causaRaiz?: string;
  acaoImediata?: string;
  versao: number;
  syncStatus: SyncStatus;
  syncedAt?: string;
  createdAt: string;
  updatedAt: string;
  evidencias?: Evidencia[];
  assinaturas?: Assinatura[];
}

export interface Evidencia {
  id: string;
  clientId: string;
  relatoId: string;
  localUri: string;
  remoteUrl?: string;
  tipo: 'imagem' | 'video' | 'documento';
  nomeArquivo: string;
  tamanhoBytes?: number;
  mimeType?: string;
  latitude?: number;
  longitude?: number;
  capturedAt: string;
  syncStatus: SyncStatus;
}

export interface Assinatura {
  id: string;
  clientId: string;
  relatoId: string;
  assinanteNome: string;
  assinanteCargo?: string;
  localUri: string;
  remoteUrl?: string;
  latitude?: number;
  longitude?: number;
  syncStatus: SyncStatus;
  createdAt: string;
}

export type OperacaoTipo = 'create' | 'update' | 'delete' | 'upload';

export interface OperacaoPendente {
  id: string;
  tipo: OperacaoTipo;
  entidade: 'relato' | 'evidencia' | 'assinatura';
  entidadeId: string;
  clientId?: string;
  payload: Record<string, any>;
  tentativas: number;
  erroMsg?: string;
  createdAt: string;
}

export interface AuthResponse {
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
  user: User;
}

export interface SelectOption {
  label: string;
  value: string;
}
TYPES

echo "--- Criando src/constants/index.ts ---"
cat > src/constants/index.ts << 'CONSTANTS'
export const Colors = {
  primary:     '#0F2D5E',
  primaryMid:  '#1A4A8A',
  primaryLight:'#2563EB',
  accent:      '#F97316',
  white:       '#FFFFFF',
  gray50:      '#F8FAFC',
  gray100:     '#F1F5F9',
  gray200:     '#E2E8F0',
  gray300:     '#CBD5E1',
  gray500:     '#64748B',
  gray700:     '#334155',
  gray900:     '#0F172A',
  success:     '#16A34A',
  successLight:'#DCFCE7',
  warning:     '#D97706',
  warningLight:'#FEF9C3',
  danger:      '#DC2626',
  dangerLight: '#FEE2E2',
  info:        '#0EA5E9',
  infoLight:   '#E0F2FE',
  bg:          '#F0F4F8',
  surface:     '#FFFFFF',
  border:      '#E2E8F0',
} as const;

export const Typography = {
  h1:     { fontSize: 28, fontWeight: '800' as const, lineHeight: 36 },
  h2:     { fontSize: 22, fontWeight: '700' as const, lineHeight: 30 },
  h3:     { fontSize: 18, fontWeight: '700' as const, lineHeight: 26 },
  h4:     { fontSize: 16, fontWeight: '600' as const, lineHeight: 22 },
  body:   { fontSize: 14, fontWeight: '400' as const, lineHeight: 20 },
  bodyMd: { fontSize: 15, fontWeight: '400' as const, lineHeight: 22 },
  caption:{ fontSize: 12, fontWeight: '400' as const, lineHeight: 16 },
  label:  { fontSize: 12, fontWeight: '700' as const, lineHeight: 16 },
  button: { fontSize: 15, fontWeight: '700' as const, lineHeight: 22 },
} as const;

export const Spacing = { xs: 4, sm: 8, md: 16, lg: 24, xl: 32, xxl: 48 } as const;
export const Radius  = { sm: 6, md: 10, lg: 16, full: 999 } as const;
export const Shadow  = {
  sm: { shadowColor:'#000', shadowOffset:{width:0,height:1}, shadowOpacity:0.05, shadowRadius:2, elevation:2 },
  md: { shadowColor:'#000', shadowOffset:{width:0,height:4}, shadowOpacity:0.08, shadowRadius:8, elevation:4 },
} as const;

export const TIPO_LABELS: Record<string, string> = {
  INCIDENTE:           'Incidente',
  QUASE_ACIDENTE:      'Quase Acidente',
  CONDICAO_INSEGURA:   'Cond. Insegura',
  ATO_INSEGURO:        'Ato Inseguro',
  SUGESTAO_MELHORIA:   'Sugestao',
  OBSERVACAO_POSITIVA: 'Obs. Positiva',
};

export const GRAVIDADE_LABELS: Record<string, string> = {
  BAIXA:  'Baixa', MEDIA: 'Media', ALTA: 'Alta', CRITICA: 'Critica',
};

export const STATUS_LABELS: Record<string, string> = {
  RASCUNHO:'Rascunho', ENVIADO:'Enviado', EM_ANALISE:'Em Analise',
  EM_TRATAMENTO:'Em Tratamento', CONCLUIDO:'Concluido', CANCELADO:'Cancelado',
};

export const GRAVIDADE_COLORS: Record<string, string> = {
  BAIXA: Colors.success, MEDIA: Colors.warning, ALTA: Colors.accent, CRITICA: Colors.danger,
};

export const STATUS_COLORS: Record<string, string> = {
  RASCUNHO: Colors.gray500, ENVIADO: Colors.info, EM_ANALISE: Colors.warning,
  EM_TRATAMENTO: Colors.accent, CONCLUIDO: Colors.success, CANCELADO: Colors.danger,
};

export const STORAGE_KEYS = {
  ACCESS_TOKEN:  '@sst/access_token',
  REFRESH_TOKEN: '@sst/refresh_token',
  USER:          '@sst/user',
  DEVICE_ID:     '@sst/device_id',
  RELATOS:       '@sst/relatos',
  EVIDENCIAS:    '@sst/evidencias',
  ASSINATURAS:   '@sst/assinaturas',
  PENDING_OPS:   '@sst/pending_ops',
  LAST_SYNC:     '@sst/last_sync',
} as const;

export const API_URL = process.env.EXPO_PUBLIC_API_URL ?? 'https://sst-backend.railway.app/api/v1';
CONSTANTS

echo "--- Criando src/components/ui/index.tsx ---"
cat > src/components/ui/index.tsx << 'UICOMP'
import React from 'react';
import {
  View, Text, TouchableOpacity, TextInput, ActivityIndicator,
  StyleSheet, ViewStyle, TouchableOpacityProps, TextInputProps,
} from 'react-native';
import { Colors, Typography, Spacing, Radius, Shadow } from '../../constants';

interface ButtonProps extends TouchableOpacityProps {
  label: string;
  variant?: 'primary' | 'secondary' | 'danger' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  loading?: boolean;
  icon?: React.ReactNode;
}

export function Button({ label, variant='primary', size='md', loading, icon, disabled, style, ...props }: ButtonProps) {
  const bg = { primary: Colors.primary, secondary: Colors.white, danger: Colors.danger, ghost: 'transparent' }[variant];
  const color = variant === 'secondary' || variant === 'ghost' ? Colors.primary : Colors.white;
  const border = variant === 'secondary' ? { borderWidth: 1.5, borderColor: Colors.primary } : {};
  const pad = { sm: 10, md: 14, lg: 18 }[size];
  const fs  = { sm: 13, md: 15, lg: 16 }[size];
  return (
    <TouchableOpacity style={[styles.btn, { backgroundColor: bg, paddingVertical: pad }, border, (disabled||loading) && styles.btnDisabled, style]} disabled={disabled||loading} activeOpacity={0.8} {...props}>
      {loading ? <ActivityIndicator color={color} size="small" /> : (
        <View style={styles.btnRow}>
          {icon && <View style={{ marginRight: 8 }}>{icon}</View>}
          <Text style={[styles.btnText, { color, fontSize: fs }]}>{label}</Text>
        </View>
      )}
    </TouchableOpacity>
  );
}

interface InputProps extends TextInputProps { label?: string; error?: string; required?: boolean; }

export function Input({ label, error, required, style, ...props }: InputProps) {
  return (
    <View style={{ marginBottom: Spacing.md }}>
      {label && <Text style={styles.inputLabel}>{label}{required && <Text style={{ color: Colors.danger }}> *</Text>}</Text>}
      <TextInput style={[styles.input, error ? styles.inputError : undefined, style]} placeholderTextColor={Colors.gray300} {...props} />
      {error && <Text style={styles.errorText}>{error}</Text>}
    </View>
  );
}

export function Card({ children, style, onPress }: { children: React.ReactNode; style?: ViewStyle; onPress?: () => void }) {
  const content = <View style={[styles.card, style]}>{children}</View>;
  return onPress ? <TouchableOpacity onPress={onPress} activeOpacity={0.7}>{content}</TouchableOpacity> : content;
}

export function Badge({ label, color=Colors.primary, bgColor, size='md' }: { label:string; color?:string; bgColor?:string; size?:'sm'|'md'; }) {
  return (
    <View style={[styles.badge, { backgroundColor: bgColor ?? color+'18' }]}>
      <Text style={[styles.badgeText, { color, fontSize: size==='sm' ? 10 : 12 }]}>{label}</Text>
    </View>
  );
}

export function SyncBadge({ status }: { status: 'PENDENTE'|'SINCRONIZADO'|'ERRO' }) {
  const map = { PENDENTE: { label:'Pendente', color:Colors.warning }, SINCRONIZADO: { label:'Sincronizado', color:Colors.success }, ERRO: { label:'Erro', color:Colors.danger } };
  const { label, color } = map[status];
  return <Badge label={label} color={color} size="sm" />;
}

export function EmptyState({ icon='📋', title='Nenhum item', subtitle }: { icon?:string; title?:string; subtitle?:string; }) {
  return (
    <View style={styles.empty}>
      <Text style={styles.emptyIcon}>{icon}</Text>
      <Text style={styles.emptyTitle}>{title}</Text>
      {subtitle && <Text style={styles.emptySub}>{subtitle}</Text>}
    </View>
  );
}

export function LoadingState({ label='Carregando...' }: { label?:string }) {
  return <View style={styles.loading}><ActivityIndicator color={Colors.primary} size="large" /><Text style={styles.loadingText}>{label}</Text></View>;
}

export function NetworkBanner({ isConnected }: { isConnected: boolean }) {
  if (isConnected) return null;
  return <View style={styles.offlineBanner}><Text style={styles.offlineText}>Voce esta offline — dados salvos localmente</Text></View>;
}

const styles = StyleSheet.create({
  btn: { borderRadius: Radius.md, alignItems:'center', justifyContent:'center', paddingHorizontal: Spacing.lg, ...Shadow.sm },
  btnRow: { flexDirection:'row', alignItems:'center' },
  btnText: { ...Typography.button, letterSpacing: 0.3 },
  btnDisabled: { opacity: 0.5 },
  inputLabel: { ...Typography.label, color: Colors.gray700, marginBottom: 6, textTransform:'uppercase', letterSpacing: 0.5 },
  input: { borderWidth: 1.5, borderColor: Colors.border, borderRadius: Radius.md, padding: Spacing.md, ...Typography.body, color: Colors.gray900, backgroundColor: Colors.white },
  inputError: { borderColor: Colors.danger },
  errorText: { ...Typography.caption, color: Colors.danger, marginTop: 4 },
  card: { backgroundColor: Colors.white, borderRadius: Radius.lg, padding: Spacing.md, ...Shadow.sm, marginBottom: Spacing.sm },
  badge: { paddingHorizontal: 8, paddingVertical: 3, borderRadius: Radius.full, alignSelf:'flex-start' },
  badgeText: { fontWeight:'700', letterSpacing: 0.3 },
  empty: { alignItems:'center', paddingVertical: Spacing.xxl },
  emptyIcon: { fontSize: 48, marginBottom: Spacing.sm },
  emptyTitle: { ...Typography.h4, color: Colors.gray700, marginBottom: 4 },
  emptySub: { ...Typography.body, color: Colors.gray500, textAlign:'center' },
  loading: { flex:1, alignItems:'center', justifyContent:'center', gap: 12 },
  loadingText: { ...Typography.body, color: Colors.gray500 },
  offlineBanner: { backgroundColor: Colors.warning, padding: Spacing.sm, alignItems:'center' },
  offlineText: { ...Typography.caption, color: Colors.white, fontWeight:'700' },
});
UICOMP

echo "--- Criando src/repositories/index.ts ---"
cat > src/repositories/index.ts << 'REPOS'
import AsyncStorage from '@react-native-async-storage/async-storage';
import { STORAGE_KEYS } from '../constants';
import type { Relato, Evidencia, Assinatura, OperacaoPendente } from '../types';

function uuid(): string {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, c => {
    const r = Math.random() * 16 | 0;
    return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
  });
}

async function getJson<T>(key: string, fallback: T): Promise<T> {
  try { const raw = await AsyncStorage.getItem(key); return raw ? JSON.parse(raw) as T : fallback; }
  catch { return fallback; }
}

async function setJson(key: string, value: unknown): Promise<void> {
  await AsyncStorage.setItem(key, JSON.stringify(value));
}

export const RelatosRepository = {
  async getAll(): Promise<Relato[]> { return getJson<Relato[]>(STORAGE_KEYS.RELATOS, []); },
  async getById(id: string): Promise<Relato | null> {
    const r = await this.getAll(); return r.find(x => x.id === id || x.clientId === id) ?? null;
  },
  async filter(opts: { status?: string; search?: string }): Promise<Relato[]> {
    let r = await this.getAll();
    if (opts.status) r = r.filter(x => x.status === opts.status);
    if (opts.search) { const q = opts.search.toLowerCase(); r = r.filter(x => x.titulo.toLowerCase().includes(q) || x.descricao.toLowerCase().includes(q)); }
    return r.sort((a,b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
  },
  async create(data: Omit<Relato,'id'|'clientId'|'versao'|'syncStatus'|'createdAt'|'updatedAt'>): Promise<Relato> {
    const r = await this.getAll(); const now = new Date().toISOString();
    const relato: Relato = { ...data, id: uuid(), clientId: uuid(), versao: 1, syncStatus: 'PENDENTE', createdAt: now, updatedAt: now };
    await setJson(STORAGE_KEYS.RELATOS, [...r, relato]); return relato;
  },
  async update(id: string, data: Partial<Relato>): Promise<Relato> {
    const r = await this.getAll(); const idx = r.findIndex(x => x.id === id || x.clientId === id);
    if (idx === -1) throw new Error('Relato nao encontrado');
    const updated = { ...r[idx], ...data, versao: r[idx].versao+1, updatedAt: new Date().toISOString(), syncStatus: 'PENDENTE' as const };
    r[idx] = updated; await setJson(STORAGE_KEYS.RELATOS, r); return updated;
  },
  async markSynced(clientId: string, serverId: string): Promise<void> {
    const r = await this.getAll(); const idx = r.findIndex(x => x.clientId === clientId);
    if (idx === -1) return; r[idx] = { ...r[idx], id: serverId, syncStatus: 'SINCRONIZADO' }; await setJson(STORAGE_KEYS.RELATOS, r);
  },
  async mergeFromServer(srv: Partial<Relato>[]): Promise<void> {
    const local = await this.getAll(); const map = new Map(local.map(r => [r.clientId??r.id, r]));
    for (const s of srv) { const k = s.clientId??s.id??''; const ex = map.get(k);
      if (!ex) map.set(k, { ...s, syncStatus:'SINCRONIZADO' } as Relato);
      else if ((s.versao??0) > ex.versao) map.set(k, { ...ex, ...s, syncStatus:'SINCRONIZADO' }); }
    await setJson(STORAGE_KEYS.RELATOS, [...map.values()]);
  },
  async countPending(): Promise<number> { return (await this.getAll()).filter(r => r.syncStatus==='PENDENTE').length; },
};

export const EvidenciasRepository = {
  async getAll(): Promise<Evidencia[]> { return getJson<Evidencia[]>(STORAGE_KEYS.EVIDENCIAS, []); },
  async getByRelatoId(id: string): Promise<Evidencia[]> { return (await this.getAll()).filter(e => e.relatoId===id); },
  async create(data: Omit<Evidencia,'id'|'clientId'|'syncStatus'>): Promise<Evidencia> {
    const all = await this.getAll(); const ev: Evidencia = { ...data, id: uuid(), clientId: uuid(), syncStatus:'PENDENTE' };
    await setJson(STORAGE_KEYS.EVIDENCIAS, [...all, ev]); return ev;
  },
  async remove(clientId: string): Promise<void> {
    await setJson(STORAGE_KEYS.EVIDENCIAS, (await this.getAll()).filter(e => e.clientId!==clientId));
  },
};

export const AssinaturasRepository = {
  async getAll(): Promise<Assinatura[]> { return getJson<Assinatura[]>(STORAGE_KEYS.ASSINATURAS, []); },
  async getByRelatoId(id: string): Promise<Assinatura[]> { return (await this.getAll()).filter(a => a.relatoId===id); },
  async create(data: Omit<Assinatura,'id'|'clientId'|'syncStatus'|'createdAt'>): Promise<Assinatura> {
    const all = await this.getAll(); const a: Assinatura = { ...data, id: uuid(), clientId: uuid(), syncStatus:'PENDENTE', createdAt: new Date().toISOString() };
    await setJson(STORAGE_KEYS.ASSINATURAS, [...all, a]); return a;
  },
};

export const SyncQueueRepository = {
  async getAll(): Promise<OperacaoPendente[]> { return getJson<OperacaoPendente[]>(STORAGE_KEYS.PENDING_OPS, []); },
  async add(op: Omit<OperacaoPendente,'id'|'tentativas'|'createdAt'>): Promise<void> {
    const q = await this.getAll();
    await setJson(STORAGE_KEYS.PENDING_OPS, [...q, { ...op, id: uuid(), tentativas:0, createdAt: new Date().toISOString() }]);
  },
  async remove(id: string): Promise<void> { await setJson(STORAGE_KEYS.PENDING_OPS, (await this.getAll()).filter(o => o.id!==id)); },
  async count(): Promise<number> { return (await this.getAll()).length; },
  async clear(): Promise<void> { await AsyncStorage.removeItem(STORAGE_KEYS.PENDING_OPS); },
};

export const SyncMetaRepository = {
  async getLastSync(): Promise<string> { return (await AsyncStorage.getItem(STORAGE_KEYS.LAST_SYNC)) ?? new Date(0).toISOString(); },
  async setLastSync(ts: string): Promise<void> { await AsyncStorage.setItem(STORAGE_KEYS.LAST_SYNC, ts); },
};
REPOS

echo "--- Criando src/services/api.ts ---"
cat > src/services/api.ts << 'APITS'
import axios, { AxiosInstance } from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { API_URL, STORAGE_KEYS } from '../constants';
import { AuthResponse } from '../types';

const api: AxiosInstance = axios.create({ baseURL: API_URL, timeout: 30000, headers: { 'Content-Type': 'application/json' } });

api.interceptors.request.use(async (config) => {
  const token = await AsyncStorage.getItem(STORAGE_KEYS.ACCESS_TOKEN);
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

api.interceptors.response.use(r => r, async (error) => {
  if (error.response?.status === 401 && !error.config._retry) {
    error.config._retry = true;
    try {
      const rt = await AsyncStorage.getItem(STORAGE_KEYS.REFRESH_TOKEN);
      if (!rt) throw new Error('no rt');
      const { data } = await axios.post<AuthResponse>(`${API_URL}/auth/refresh`, { refreshToken: rt });
      await AsyncStorage.multiSet([[STORAGE_KEYS.ACCESS_TOKEN, data.accessToken],[STORAGE_KEYS.REFRESH_TOKEN, data.refreshToken]]);
      error.config.headers.Authorization = `Bearer ${data.accessToken}`;
      return api(error.config);
    } catch {
      await AsyncStorage.multiRemove([STORAGE_KEYS.ACCESS_TOKEN, STORAGE_KEYS.REFRESH_TOKEN, STORAGE_KEYS.USER]);
    }
  }
  return Promise.reject(error);
});

export { api };
export const authApi = {
  login: (email: string, senha: string) => api.post<AuthResponse>('/auth/login', { email, senha }),
  refresh: (rt: string) => api.post<AuthResponse>('/auth/refresh', { refreshToken: rt }),
  logout: (rt: string) => api.post('/auth/logout', { refreshToken: rt }),
};
export const relatosApi = {
  create: (data: any) => api.post('/relatos', data),
  list: (params?: any) => api.get('/relatos', { params }),
  get: (id: string) => api.get(`/relatos/${id}`),
  update: (id: string, data: any) => api.patch(`/relatos/${id}`, data),
};
export const syncApi = {
  push: (payload: any) => api.post('/sync', payload),
  pull: (since: string) => api.get('/sync/pull', { params: { since } }),
};
APITS

echo "--- Criando src/stores/index.ts ---"
cat > src/stores/index.ts << 'STORES'
import { create } from 'zustand';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { STORAGE_KEYS } from '../constants';
import type { User, Relato } from '../types';
import { RelatosRepository, SyncQueueRepository, SyncMetaRepository } from '../repositories';
import { authApi, relatosApi, syncApi } from '../services/api';

interface AuthState {
  user: User | null; isAuthenticated: boolean; isLoading: boolean; error: string | null;
  login: (email: string, senha: string) => Promise<void>;
  logout: () => Promise<void>;
  restoreSession: () => Promise<void>;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null, isAuthenticated: false, isLoading: false, error: null,
  login: async (email, senha) => {
    set({ isLoading: true, error: null });
    try {
      const { data } = await authApi.login(email, senha);
      await AsyncStorage.multiSet([[STORAGE_KEYS.ACCESS_TOKEN, data.accessToken],[STORAGE_KEYS.REFRESH_TOKEN, data.refreshToken],[STORAGE_KEYS.USER, JSON.stringify(data.user)]]);
      set({ user: data.user, isAuthenticated: true, isLoading: false });
    } catch (err: any) {
      set({ error: err?.response?.data?.message ?? 'Erro ao fazer login. Verifique suas credenciais.', isLoading: false });
      throw err;
    }
  },
  logout: async () => {
    try { const rt = await AsyncStorage.getItem(STORAGE_KEYS.REFRESH_TOKEN); if (rt) await authApi.logout(rt).catch(()=>{}); }
    finally { await AsyncStorage.multiRemove([STORAGE_KEYS.ACCESS_TOKEN, STORAGE_KEYS.REFRESH_TOKEN, STORAGE_KEYS.USER]); set({ user: null, isAuthenticated: false }); }
  },
  restoreSession: async () => {
    const raw = await AsyncStorage.getItem(STORAGE_KEYS.USER); const token = await AsyncStorage.getItem(STORAGE_KEYS.ACCESS_TOKEN);
    if (raw && token) set({ user: JSON.parse(raw), isAuthenticated: true });
  },
}));

interface RelatosState {
  relatos: Relato[]; isLoading: boolean; error: string | null;
  loadRelatos: (opts?: { search?: string; status?: string }) => Promise<void>;
  createRelato: (data: any) => Promise<Relato>;
  refreshFromServer: () => Promise<void>;
}

export const useRelatosStore = create<RelatosState>((set, get) => ({
  relatos: [], isLoading: false, error: null,
  loadRelatos: async (opts={}) => {
    set({ isLoading: true });
    try { const r = await RelatosRepository.filter(opts); set({ relatos: r, isLoading: false }); }
    catch (err: any) { set({ error: err.message, isLoading: false }); }
  },
  createRelato: async (data) => {
    const { user } = useAuthStore.getState();
    if (!user) throw new Error('Nao autenticado');
    const relato = await RelatosRepository.create({ ...data, tenantId: user.tenantId, autorId: user.id });
    await SyncQueueRepository.add({ tipo:'create', entidade:'relato', entidadeId: relato.id, clientId: relato.clientId, payload: relato });
    set(s => ({ relatos: [relato, ...s.relatos] })); return relato;
  },
  refreshFromServer: async () => {
    try { const { data } = await relatosApi.list({ limit: 50 }); await RelatosRepository.mergeFromServer(data.data??[]); await get().loadRelatos(); }
    catch {}
  },
}));

type SyncStep = 'idle'|'pushing'|'pulling'|'done'|'error';
interface SyncState {
  step: SyncStep; pendingCount: number; lastSync: string | null; error: string | null;
  loadPendingCount: () => Promise<void>; sync: () => Promise<void>;
}

export const useSyncStore = create<SyncState>((set, get) => ({
  step:'idle', pendingCount:0, lastSync:null, error:null,
  loadPendingCount: async () => {
    const count = await SyncQueueRepository.count(); const lastSync = await SyncMetaRepository.getLastSync();
    set({ pendingCount: count, lastSync });
  },
  sync: async () => {
    const queue = await SyncQueueRepository.getAll(); if (queue.length===0) return;
    set({ step:'pushing', error:null });
    try {
      const inserts = queue.filter(o=>o.tipo==='create').map(o=>({ entidade:o.entidade, clientId:o.clientId, data:o.payload }));
      const updates = queue.filter(o=>o.tipo==='update').map(o=>({ entidade:o.entidade, id:o.entidadeId, data:o.payload }));
      await syncApi.push({ inserts, updates, deletes:[] });
      for (const op of queue) { if (op.tipo==='create'&&op.clientId) await RelatosRepository.markSynced(op.clientId, op.entidadeId); await SyncQueueRepository.remove(op.id); }
      set({ step:'pulling' });
      const since = await SyncMetaRepository.getLastSync(); const { data: pull } = await syncApi.pull(since);
      await RelatosRepository.mergeFromServer(pull.relatos??[]); await SyncMetaRepository.setLastSync(pull.serverTimestamp);
      await useRelatosStore.getState().loadRelatos();
      const pendingCount = await SyncQueueRepository.count(); set({ step:'done', pendingCount, lastSync: pull.serverTimestamp });
      setTimeout(()=>set({ step:'idle' }), 2000);
    } catch (err: any) {
      set({ step:'error', error: err?.message??'Erro na sincronizacao' });
      setTimeout(()=>set({ step:'idle', error:null }), 3000);
    }
  },
}));

export const useNetworkStore = create<{ isConnected: boolean; setConnected:(v:boolean)=>void }>(set => ({
  isConnected: true, setConnected: v => set({ isConnected: v }),
}));
STORES

echo "--- Criando src/hooks/useSafeScreen.tsx ---"
cat > src/hooks/useSafeScreen.tsx << 'HOOKS'
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { Platform, StatusBar } from 'react-native';

export function useSafeScreen() {
  const insets = useSafeAreaInsets();
  return {
    top: Platform.OS==='ios' ? insets.top : (StatusBar.currentHeight??0),
    bottom: insets.bottom, left: insets.left, right: insets.right,
  };
}
HOOKS

echo "--- Criando src/app/_layout.tsx ---"
cat > src/app/_layout.tsx << 'LAYOUT'
import { useEffect, useRef } from 'react';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { Platform } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import NetInfo from '@react-native-community/netinfo';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useAuthStore, useNetworkStore, useSyncStore } from '../stores';
import { Colors } from '../constants';

const queryClient = new QueryClient({ defaultOptions: { queries: { retry:1, staleTime:30000 } } });

export default function RootLayout() {
  const { restoreSession, isAuthenticated } = useAuthStore();
  const { setConnected, isConnected } = useNetworkStore();
  const { sync } = useSyncStore();

  useEffect(() => { restoreSession(); }, []);
  useEffect(() => { const u = NetInfo.addEventListener(s => setConnected(!!(s.isConnected&&s.isInternetReachable))); return u; }, []);
  useEffect(() => { if (isConnected && isAuthenticated) sync().catch(()=>{}); }, [isConnected]);

  return (
    <SafeAreaProvider>
      <QueryClientProvider client={queryClient}>
        <StatusBar style="light" backgroundColor={Colors.primary} translucent={Platform.OS==='android'} />
        <Stack screenOptions={{ headerShown:false, animation: Platform.OS==='ios'?'default':'slide_from_right', gestureEnabled: Platform.OS==='ios' }}>
          <Stack.Screen name="index" />
          <Stack.Screen name="auth/login" />
          <Stack.Screen name="relatos/dashboard" />
          <Stack.Screen name="relatos/index" />
          <Stack.Screen name="relatos/novo" />
          <Stack.Screen name="relatos/[id]/index" />
          <Stack.Screen name="relatos/[id]/evidencias" />
          <Stack.Screen name="relatos/[id]/assinatura" />
        </Stack>
      </QueryClientProvider>
    </SafeAreaProvider>
  );
}
LAYOUT

echo "--- Criando src/app/index.tsx ---"
cat > src/app/index.tsx << 'INDEXTS'
import { useEffect } from 'react';
import { router } from 'expo-router';
import { View, ActivityIndicator } from 'react-native';
import { useAuthStore } from '../stores';
import { Colors } from '../constants';

export default function Index() {
  const { restoreSession } = useAuthStore();
  useEffect(() => {
    restoreSession().then(() => {
      setTimeout(() => {
        if (useAuthStore.getState().isAuthenticated) router.replace('/relatos/dashboard');
        else router.replace('/auth/login');
      }, 100);
    });
  }, []);
  return <View style={{ flex:1, alignItems:'center', justifyContent:'center', backgroundColor:Colors.primary }}><ActivityIndicator size="large" color={Colors.white} /></View>;
}
INDEXTS

echo "--- Criando src/app/auth/login.tsx ---"
cat > src/app/auth/login.tsx << 'LOGINSCREEN'
import React, { useState } from 'react';
import { View, Text, StyleSheet, KeyboardAvoidingView, Platform, ScrollView, Alert, TouchableOpacity } from 'react-native';
import { router } from 'expo-router';
import { useForm, Controller } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useAuthStore, useNetworkStore } from '../../stores';
import { Button, Input, NetworkBanner } from '../../components/ui';
import { Colors, Typography, Spacing, Radius } from '../../constants';

const schema = z.object({ email: z.string().email('E-mail invalido'), senha: z.string().min(6,'Minimo 6 caracteres') });
type F = z.infer<typeof schema>;

export default function LoginScreen() {
  const { login, isLoading, error } = useAuthStore();
  const { isConnected } = useNetworkStore();
  const [showSenha, setShowSenha] = useState(false);
  const { control, handleSubmit, formState:{ errors } } = useForm<F>({ resolver: zodResolver(schema), defaultValues:{ email:'', senha:'' } });

  const onSubmit = async (d: F) => {
    if (!isConnected) { Alert.alert('Sem conexao','O login requer internet.'); return; }
    try { await login(d.email, d.senha); router.replace('/relatos/dashboard'); } catch {}
  };

  return (
    <SafeAreaView style={s.safeArea} edges={['top','left','right']}>
      <NetworkBanner isConnected={isConnected} />
      <KeyboardAvoidingView style={{ flex:1 }} behavior={Platform.OS==='ios'?'padding':'height'}>
        <ScrollView contentContainerStyle={s.scroll} keyboardShouldPersistTaps="handled" bounces={false}>
          <View style={s.header}>
            <View style={s.logoBox}><Text style={s.logoIcon}>🛡️</Text></View>
            <Text style={s.title}>SST Platform</Text>
            <Text style={s.subtitle}>Seguranca e Saude no Trabalho</Text>
          </View>
          <View style={s.form}>
            <Text style={s.formTitle}>Entrar na sua conta</Text>
            <Controller control={control} name="email" render={({ field:{ onChange, value } }) => (
              <Input label="E-mail" required placeholder="seu@email.com" keyboardType="email-address" autoCapitalize="none" value={value} onChangeText={onChange} error={errors.email?.message} />
            )} />
            <Controller control={control} name="senha" render={({ field:{ onChange, value } }) => (
              <View>
                <Input label="Senha" required placeholder="Senha" secureTextEntry={!showSenha} value={value} onChangeText={onChange} error={errors.senha?.message} onSubmitEditing={handleSubmit(onSubmit)} />
                <TouchableOpacity onPress={()=>setShowSenha(!showSenha)} style={s.showBtn}>
                  <Text style={s.showTxt}>{showSenha?'Ocultar':'Mostrar'}</Text>
                </TouchableOpacity>
              </View>
            )} />
            {error && <View style={s.errorBox}><Text style={s.errorTxt}>⚠️ {error}</Text></View>}
            <Button label={isLoading?'Entrando...':'Entrar'} loading={isLoading} onPress={handleSubmit(onSubmit)} size="lg" style={{ marginTop: Spacing.sm }} />
          </View>
          <Text style={s.footer}>SST Platform v1.0</Text>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}

const s = StyleSheet.create({
  safeArea: { flex:1, backgroundColor: Colors.primary },
  scroll: { flexGrow:1, justifyContent:'center', padding: Spacing.lg, paddingBottom: Spacing.xxl },
  header: { alignItems:'center', marginBottom: Spacing.xl },
  logoBox: { width:80, height:80, borderRadius:20, backgroundColor:'rgba(255,255,255,0.15)', alignItems:'center', justifyContent:'center', marginBottom: Spacing.md },
  logoIcon: { fontSize:40 },
  title: { ...Typography.h1, color: Colors.white, textAlign:'center' },
  subtitle: { ...Typography.body, color:'rgba(255,255,255,0.7)', textAlign:'center', marginTop:4 },
  form: { backgroundColor: Colors.white, borderRadius:20, padding: Spacing.lg, marginBottom: Spacing.lg },
  formTitle: { ...Typography.h3, color: Colors.gray900, marginBottom: Spacing.lg },
  showBtn: { alignSelf:'flex-end', marginTop:-Spacing.sm, marginBottom: Spacing.md },
  showTxt: { ...Typography.caption, color: Colors.primaryLight, fontWeight:'600' },
  errorBox: { backgroundColor: Colors.dangerLight, borderRadius:8, padding: Spacing.sm, marginBottom: Spacing.sm },
  errorTxt: { ...Typography.body, color: Colors.danger },
  footer: { ...Typography.caption, color:'rgba(255,255,255,0.4)', textAlign:'center' },
});
LOGINSCREEN

echo "--- Criando src/app/relatos/dashboard.tsx ---"
cat > src/app/relatos/dashboard.tsx << 'DASH'
import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, RefreshControl } from 'react-native';
import { router } from 'expo-router';
import { useAuthStore, useRelatosStore, useSyncStore, useNetworkStore } from '../../stores';
import { RelatosRepository, SyncQueueRepository } from '../../repositories';
import { NetworkBanner } from '../../components/ui';
import { Colors, Typography, Spacing, Radius, Shadow } from '../../constants';

export default function DashboardScreen() {
  const { user, logout } = useAuthStore();
  const { sync, step, pendingCount, lastSync, loadPendingCount } = useSyncStore();
  const { isConnected } = useNetworkStore();
  const [stats, setStats] = useState({ total:0, pendentes:0, sincronizados:0, criticos:0 });
  const [refreshing, setRefreshing] = useState(false);

  const load = async () => {
    const r = await RelatosRepository.getAll();
    setStats({ total:r.length, pendentes:r.filter(x=>x.syncStatus==='PENDENTE').length, sincronizados:r.filter(x=>x.syncStatus==='SINCRONIZADO').length, criticos:r.filter(x=>x.gravidade==='CRITICA').length });
    await loadPendingCount();
  };

  useEffect(() => { load(); }, []);
  const onRefresh = async () => { setRefreshing(true); await load(); setRefreshing(false); };
  const handleSync = async () => { if (!isConnected) return; await sync(); await load(); };
  const hoje = new Date().toLocaleDateString('pt-BR',{ weekday:'long', day:'numeric', month:'long' });

  return (
    <View style={{ flex:1, backgroundColor: Colors.bg }}>
      <NetworkBanner isConnected={isConnected} />
      <View style={s.header}>
        <View>
          <Text style={s.greeting}>Ola, {user?.nome?.split(' ')[0]} 👋</Text>
          <Text style={s.date}>{hoje}</Text>
        </View>
        <TouchableOpacity onPress={logout} style={s.avatar}>
          <Text style={s.avatarTxt}>{user?.nome?.charAt(0).toUpperCase()??'?'}</Text>
        </TouchableOpacity>
      </View>
      <ScrollView contentContainerStyle={s.scroll} refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} colors={[Colors.primary]} />}>
        <View style={[s.statusBar, { backgroundColor: isConnected?Colors.successLight:Colors.warningLight }]}>
          <Text style={[s.statusTxt, { color: isConnected?Colors.success:Colors.warning }]}>
            {isConnected?'🟢 Online':'🟡 Offline'}{pendingCount>0?`  ·  ${pendingCount} pendentes`:''}
          </Text>
          {isConnected&&pendingCount>0&&<TouchableOpacity onPress={handleSync}><Text style={s.syncNow}>Sincronizar</Text></TouchableOpacity>}
        </View>
        <Text style={s.sectionLabel}>RESUMO</Text>
        <View style={s.grid}>
          {[{label:'Total',value:stats.total,color:Colors.primary,icon:'📋'},{label:'Pendentes',value:stats.pendentes,color:Colors.warning,icon:'⏳'},{label:'Sincronizados',value:stats.sincronizados,color:Colors.success,icon:'✅'},{label:'Criticos',value:stats.criticos,color:Colors.danger,icon:'🚨'}].map(c=>(
            <View key={c.label} style={[s.card,{borderLeftColor:c.color}]}>
              <Text style={s.cardIcon}>{c.icon}</Text>
              <Text style={[s.cardVal,{color:c.color}]}>{c.value}</Text>
              <Text style={s.cardLabel}>{c.label}</Text>
            </View>
          ))}
        </View>
        <Text style={s.sectionLabel}>ACOES RAPIDAS</Text>
        {[{icon:'➕',label:'Novo Relato',sub:'Registrar ocorrencia',color:Colors.primary,onPress:()=>router.push('/relatos/novo')},{icon:'📋',label:'Meus Relatos',sub:'Ver lista completa',color:Colors.primaryMid,onPress:()=>router.push('/relatos')},{icon:'🔄',label:'Sincronizar',sub:isConnected?`${pendingCount} pendentes`:'Sem conexao',color:isConnected?Colors.success:Colors.gray500,onPress:handleSync,disabled:!isConnected||step!=='idle'}].map(a=>(
          <TouchableOpacity key={a.label} style={[s.action,{opacity:a.disabled?0.5:1}]} onPress={a.onPress} disabled={a.disabled} activeOpacity={0.7}>
            <View style={[s.actionIcon,{backgroundColor:a.color+'18'}]}><Text style={{fontSize:24}}>{a.icon}</Text></View>
            <View style={{flex:1}}><Text style={s.actionLabel}>{a.label}</Text><Text style={s.actionSub}>{a.sub}</Text></View>
            <Text style={s.actionArrow}>›</Text>
          </TouchableOpacity>
        ))}
        {lastSync&&<Text style={s.lastSync}>Ultimo sync: {new Date(lastSync).toLocaleString('pt-BR',{day:'2-digit',month:'2-digit',hour:'2-digit',minute:'2-digit'})}</Text>}
      </ScrollView>
    </View>
  );
}

const s = StyleSheet.create({
  header:{ backgroundColor:Colors.primary, padding:Spacing.lg, paddingTop:Spacing.xl+Spacing.lg, flexDirection:'row', justifyContent:'space-between', alignItems:'center' },
  greeting:{ ...Typography.h3, color:Colors.white },
  date:{ ...Typography.caption, color:'rgba(255,255,255,0.6)', marginTop:2 },
  avatar:{ width:44, height:44, borderRadius:22, backgroundColor:'rgba(255,255,255,0.2)', alignItems:'center', justifyContent:'center' },
  avatarTxt:{ ...Typography.h4, color:Colors.white },
  scroll:{ padding:Spacing.md, paddingBottom:Spacing.xxl },
  statusBar:{ flexDirection:'row', justifyContent:'space-between', alignItems:'center', padding:Spacing.sm, borderRadius:Radius.md, marginBottom:Spacing.md },
  statusTxt:{ ...Typography.caption, fontWeight:'700' },
  syncNow:{ ...Typography.caption, color:Colors.primary, fontWeight:'700' },
  sectionLabel:{ ...Typography.label, color:Colors.gray500, marginBottom:Spacing.sm, marginTop:Spacing.sm },
  grid:{ flexDirection:'row', flexWrap:'wrap', gap:Spacing.sm, marginBottom:Spacing.md },
  card:{ flex:1, minWidth:'45%', backgroundColor:Colors.white, borderRadius:Radius.md, padding:Spacing.md, borderLeftWidth:4, ...Shadow.sm },
  cardIcon:{ fontSize:24, marginBottom:4 },
  cardVal:{ ...Typography.h2, marginBottom:2 },
  cardLabel:{ ...Typography.caption, color:Colors.gray500 },
  action:{ backgroundColor:Colors.white, borderRadius:Radius.md, padding:Spacing.md, flexDirection:'row', alignItems:'center', gap:Spacing.md, ...Shadow.sm, marginBottom:Spacing.sm },
  actionIcon:{ width:48, height:48, borderRadius:12, alignItems:'center', justifyContent:'center' },
  actionLabel:{ ...Typography.h4, color:Colors.gray900 },
  actionSub:{ ...Typography.caption, color:Colors.gray500, marginTop:2 },
  actionArrow:{ fontSize:24, color:Colors.gray300 },
  lastSync:{ ...Typography.caption, color:Colors.gray500, textAlign:'center', marginTop:Spacing.sm },
});
DASH

echo "--- Criando src/app/relatos/index.tsx ---"
cat > src/app/relatos/index.tsx << 'RELATOSLIST'
import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, FlatList, TouchableOpacity, TextInput, RefreshControl } from 'react-native';
import { router } from 'expo-router';
import { useRelatosStore, useNetworkStore } from '../../stores';
import { Card, Badge, SyncBadge, EmptyState, NetworkBanner } from '../../components/ui';
import { Colors, Typography, Spacing, Radius, TIPO_LABELS, GRAVIDADE_LABELS, GRAVIDADE_COLORS, STATUS_LABELS, STATUS_COLORS } from '../../constants';
import type { Relato, RelatoStatus } from '../../types';

const FILTERS = [{ label:'Todos', value:'TODOS' },{ label:'Rascunho', value:'RASCUNHO' },{ label:'Enviado', value:'ENVIADO' },{ label:'Em Analise', value:'EM_ANALISE' },{ label:'Concluido', value:'CONCLUIDO' }];

export default function RelatosListScreen() {
  const { relatos, loadRelatos, refreshFromServer } = useRelatosStore();
  const { isConnected } = useNetworkStore();
  const [search, setSearch] = useState('');
  const [filter, setFilter] = useState<RelatoStatus|'TODOS'>('TODOS');
  const [refreshing, setRefreshing] = useState(false);

  useEffect(() => { loadRelatos({ search, status: filter==='TODOS'?undefined:filter }); }, [search, filter]);
  const onRefresh = async () => { setRefreshing(true); if (isConnected) await refreshFromServer(); else await loadRelatos(); setRefreshing(false); };

  return (
    <View style={{ flex:1, backgroundColor:Colors.bg }}>
      <NetworkBanner isConnected={isConnected} />
      <View style={s.header}>
        <TouchableOpacity onPress={()=>router.back()} style={s.backBtn}><Text style={s.backIcon}>←</Text></TouchableOpacity>
        <Text style={s.headerTitle}>Meus Relatos</Text>
        <TouchableOpacity style={s.addBtn} onPress={()=>router.push('/relatos/novo')}><Text style={s.addIcon}>＋</Text></TouchableOpacity>
      </View>
      <View style={s.searchBox}>
        <Text style={s.searchIcon}>🔍</Text>
        <TextInput style={s.searchInput} placeholder="Buscar..." placeholderTextColor={Colors.gray300} value={search} onChangeText={setSearch} />
        {search.length>0&&<TouchableOpacity onPress={()=>setSearch('')}><Text style={{color:Colors.gray500,fontSize:18}}>✕</Text></TouchableOpacity>}
      </View>
      <View style={s.filters}>
        {FILTERS.map(f=>(
          <TouchableOpacity key={f.value} style={[s.chip, filter===f.value&&s.chipActive]} onPress={()=>setFilter(f.value as any)}>
            <Text style={[s.chipTxt, filter===f.value&&s.chipTxtActive]}>{f.label}</Text>
          </TouchableOpacity>
        ))}
      </View>
      <FlatList data={relatos} keyExtractor={i=>i.clientId??i.id} contentContainerStyle={{ padding:Spacing.md, paddingBottom:Spacing.xxl }}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} colors={[Colors.primary]} />}
        ListEmptyComponent={<EmptyState icon="📋" title="Nenhum relato" subtitle="Toque em + para criar" />}
        renderItem={({ item })=>(
          <TouchableOpacity onPress={()=>router.push(`/relatos/${item.id}`)} activeOpacity={0.7}>
            <Card style={{ marginBottom:Spacing.sm }}>
              <View style={{ flexDirection:'row', justifyContent:'space-between', marginBottom:4 }}>
                <Text style={[Typography.h4,{color:Colors.gray900,flex:1,marginRight:8}]} numberOfLines={2}>{item.titulo}</Text>
                <SyncBadge status={item.syncStatus} />
              </View>
              <View style={{ flexDirection:'row', flexWrap:'wrap', gap:6 }}>
                <Badge label={TIPO_LABELS[item.tipo]??item.tipo} color={Colors.primaryLight} size="sm" />
                <Badge label={GRAVIDADE_LABELS[item.gravidade]??item.gravidade} color={GRAVIDADE_COLORS[item.gravidade]} size="sm" />
                <Badge label={STATUS_LABELS[item.status]??item.status} color={STATUS_COLORS[item.status]} size="sm" />
              </View>
              {item.localDescricao&&<Text style={[Typography.caption,{color:Colors.gray500,marginTop:4}]}>📍 {item.localDescricao}</Text>}
            </Card>
          </TouchableOpacity>
        )}
      />
    </View>
  );
}

const s = StyleSheet.create({
  header:{ backgroundColor:Colors.primary, flexDirection:'row', alignItems:'center', padding:Spacing.md, paddingTop:Spacing.xl+Spacing.sm },
  backBtn:{ padding:Spacing.xs }, backIcon:{ fontSize:24, color:Colors.white },
  headerTitle:{ ...Typography.h3, color:Colors.white, flex:1, textAlign:'center' },
  addBtn:{ width:36, height:36, borderRadius:18, backgroundColor:'rgba(255,255,255,0.2)', alignItems:'center', justifyContent:'center' },
  addIcon:{ fontSize:22, color:Colors.white, lineHeight:28 },
  searchBox:{ flexDirection:'row', alignItems:'center', backgroundColor:Colors.white, margin:Spacing.md, borderRadius:Radius.md, paddingHorizontal:Spacing.md, paddingVertical:Spacing.sm, borderWidth:1, borderColor:Colors.border },
  searchIcon:{ marginRight:Spacing.sm }, searchInput:{ flex:1, ...Typography.body, color:Colors.gray900 },
  filters:{ flexDirection:'row', paddingHorizontal:Spacing.md, gap:Spacing.xs, marginBottom:Spacing.sm, flexWrap:'wrap' },
  chip:{ paddingHorizontal:Spacing.md, paddingVertical:6, borderRadius:999, backgroundColor:Colors.white, borderWidth:1, borderColor:Colors.border },
  chipActive:{ backgroundColor:Colors.primary, borderColor:Colors.primary },
  chipTxt:{ ...Typography.caption, color:Colors.gray700, fontWeight:'600' }, chipTxtActive:{ color:Colors.white },
});
RELATOSLIST

echo "--- Criando src/app/relatos/novo.tsx ---"
cat > src/app/relatos/novo.tsx << 'NOVO'
import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, ScrollView, Alert, TouchableOpacity, ActivityIndicator } from 'react-native';
import { router } from 'expo-router';
import { useForm, Controller } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import * as Location from 'expo-location';
import { useRelatosStore } from '../../stores';
import { Input, Button } from '../../components/ui';
import { Colors, Typography, Spacing, Radius, TIPO_LABELS, GRAVIDADE_LABELS } from '../../constants';
import type { RelatoTipo, RelatoGravidade } from '../../types';

const schema = z.object({
  titulo: z.string().min(5,'Minimo 5 caracteres').max(200),
  descricao: z.string().min(10,'Descreva com mais detalhes').max(5000),
  tipo: z.enum(['INCIDENTE','QUASE_ACIDENTE','CONDICAO_INSEGURA','ATO_INSEGURO','SUGESTAO_MELHORIA','OBSERVACAO_POSITIVA']),
  gravidade: z.enum(['BAIXA','MEDIA','ALTA','CRITICA']),
  localDescricao: z.string().optional(),
});
type F = z.infer<typeof schema>;

function SelectField<T extends string>({ label, value, options, onSelect, required, error }: { label:string; value:T; options:{label:string;value:T}[]; onSelect:(v:T)=>void; required?:boolean; error?:string; }) {
  return (
    <View style={{ marginBottom: Spacing.md }}>
      <Text style={s.fieldLabel}>{label}{required&&<Text style={{color:Colors.danger}}> *</Text>}</Text>
      <View style={{ flexDirection:'row', flexWrap:'wrap', gap: Spacing.xs }}>
        {options.map(o=>(
          <TouchableOpacity key={o.value} style={[s.chip, value===o.value&&s.chipActive]} onPress={()=>onSelect(o.value)} activeOpacity={0.7}>
            <Text style={[s.chipTxt, value===o.value&&s.chipTxtActive]}>{o.label}</Text>
          </TouchableOpacity>
        ))}
      </View>
      {error&&<Text style={{...Typography.caption,color:Colors.danger,marginTop:4}}>{error}</Text>}
    </View>
  );
}

export default function NovoRelatoScreen() {
  const { createRelato } = useRelatosStore();
  const [gps, setGps] = useState<{lat:number;lon:number;acc:number}|null>(null);
  const [gpsLoading, setGpsLoading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const { control, handleSubmit, formState:{ errors } } = useForm<F>({ resolver: zodResolver(schema), defaultValues:{ titulo:'', descricao:'', tipo:'CONDICAO_INSEGURA', gravidade:'MEDIA', localDescricao:'' } });

  useEffect(() => { captureGps(); }, []);
  const captureGps = async () => {
    setGpsLoading(true);
    try {
      const { status } = await Location.requestForegroundPermissionsAsync();
      if (status!=='granted') { setGpsLoading(false); return; }
      const loc = await Location.getCurrentPositionAsync({ accuracy: Location.Accuracy.Balanced });
      setGps({ lat:loc.coords.latitude, lon:loc.coords.longitude, acc:loc.coords.accuracy??0 });
    } catch {} finally { setGpsLoading(false); }
  };

  const onSubmit = async (d: F) => {
    setSubmitting(true);
    try {
      const relato = await createRelato({ titulo:d.titulo, descricao:d.descricao, tipo:d.tipo as RelatoTipo, gravidade:d.gravidade as RelatoGravidade, localDescricao:d.localDescricao, latitude:gps?.lat, longitude:gps?.lon, precisaoGps:gps?.acc, dataOcorrencia:new Date().toISOString(), status:'RASCUNHO' });
      Alert.alert('Relato salvo!','Deseja adicionar fotos ou assinatura?',[
        { text:'Adicionar fotos', onPress:()=>router.replace(`/relatos/${relato.id}/evidencias`) },
        { text:'Assinar', onPress:()=>router.replace(`/relatos/${relato.id}/assinatura`) },
        { text:'Ver relato', onPress:()=>router.replace(`/relatos/${relato.id}`) },
      ]);
    } catch (err:any) { Alert.alert('Erro', err.message??'Nao foi possivel salvar.'); }
    finally { setSubmitting(false); }
  };

  return (
    <View style={{ flex:1, backgroundColor:Colors.bg }}>
      <View style={s.header}>
        <TouchableOpacity onPress={()=>router.back()} style={{ padding:Spacing.xs }}><Text style={{ fontSize:24, color:Colors.white }}>←</Text></TouchableOpacity>
        <Text style={s.headerTitle}>Novo Relato</Text>
        <View style={{ width:36 }} />
      </View>
      <ScrollView contentContainerStyle={{ padding:Spacing.md, paddingBottom:Spacing.xxl }} keyboardShouldPersistTaps="handled">
        <View style={[s.gpsCard,{ backgroundColor:gps?Colors.successLight:Colors.warningLight }]}>
          {gpsLoading ? <ActivityIndicator size="small" color={Colors.primary} /> : (
            <Text style={{ ...Typography.caption, color:gps?Colors.success:Colors.warning, fontWeight:'700' }}>
              {gps?`📍 GPS capturado — precisao ${gps.acc.toFixed(0)}m`:'⚠️ GPS nao disponivel'}
            </Text>
          )}
          {!gps&&!gpsLoading&&<TouchableOpacity onPress={captureGps}><Text style={{ ...Typography.caption, color:Colors.primary, fontWeight:'700' }}>Tentar novamente</Text></TouchableOpacity>}
        </View>
        <View style={{ backgroundColor:Colors.white, borderRadius:Radius.lg, padding:Spacing.md, marginBottom:Spacing.md }}>
          <Controller control={control} name="titulo" render={({ field:{ onChange, value } })=>(
            <Input label="Titulo" required placeholder="Ex: Piso escorregadio na cozinha" value={value} onChangeText={onChange} error={errors.titulo?.message} maxLength={200} />
          )} />
          <Controller control={control} name="descricao" render={({ field:{ onChange, value } })=>(
            <Input label="Descricao" required placeholder="Descreva o que foi observado..." value={value} onChangeText={onChange} error={errors.descricao?.message} multiline numberOfLines={5} style={{ height:120, textAlignVertical:'top' }} />
          )} />
          <Controller control={control} name="tipo" render={({ field:{ onChange, value } })=>(
            <SelectField label="Tipo" required value={value} options={Object.entries(TIPO_LABELS).map(([v,l])=>({ label:l, value:v as RelatoTipo }))} onSelect={onChange} error={errors.tipo?.message} />
          )} />
          <Controller control={control} name="gravidade" render={({ field:{ onChange, value } })=>(
            <SelectField label="Gravidade" required value={value} options={Object.entries(GRAVIDADE_LABELS).map(([v,l])=>({ label:l, value:v as RelatoGravidade }))} onSelect={onChange} error={errors.gravidade?.message} />
          )} />
          <Controller control={control} name="localDescricao" render={({ field:{ onChange, value } })=>(
            <Input label="Local (descricao)" placeholder="Ex: Cozinha — area das fritadeiras" value={value} onChangeText={onChange} />
          )} />
        </View>
        <Button label={submitting?'Salvando...':'Salvar Relato'} loading={submitting} onPress={handleSubmit(onSubmit)} size="lg" />
        <Text style={{ ...Typography.caption, color:Colors.gray500, textAlign:'center', marginTop:Spacing.sm }}>Dados salvos localmente mesmo sem internet</Text>
      </ScrollView>
    </View>
  );
}

const s = StyleSheet.create({
  header:{ backgroundColor:Colors.primary, flexDirection:'row', alignItems:'center', padding:Spacing.md, paddingTop:Spacing.xl+Spacing.sm },
  headerTitle:{ ...Typography.h3, color:Colors.white, flex:1, textAlign:'center' },
  gpsCard:{ flexDirection:'row', justifyContent:'space-between', alignItems:'center', padding:Spacing.md, borderRadius:Radius.md, marginBottom:Spacing.md },
  fieldLabel:{ ...Typography.label, color:Colors.gray700, marginBottom:Spacing.sm, textTransform:'uppercase', letterSpacing:0.5 },
  chip:{ paddingHorizontal:Spacing.md, paddingVertical:8, borderRadius:999, borderWidth:1.5, borderColor:Colors.border, backgroundColor:Colors.white },
  chipActive:{ backgroundColor:Colors.primary, borderColor:Colors.primary },
  chipTxt:{ ...Typography.caption, color:Colors.gray700, fontWeight:'600' }, chipTxtActive:{ color:Colors.white },
});
NOVO

echo "--- Criando src/app/relatos/[id]/index.tsx ---"
cat > "src/app/relatos/[id]/index.tsx" << 'DETAIL'
import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, RefreshControl } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import { RelatosRepository, EvidenciasRepository, AssinaturasRepository } from '../../../repositories';
import { Badge, SyncBadge, Card } from '../../../components/ui';
import { Colors, Typography, Spacing, Radius, Shadow, TIPO_LABELS, GRAVIDADE_LABELS, STATUS_LABELS, GRAVIDADE_COLORS, STATUS_COLORS } from '../../../constants';
import type { Relato } from '../../../types';

export default function RelatoDetailScreen() {
  const { id } = useLocalSearchParams<{ id:string }>();
  const [relato, setRelato] = useState<Relato|null>(null);
  const [refreshing, setRefreshing] = useState(false);

  const load = async () => { if (!id) return; setRelato(await RelatosRepository.getById(id)); };
  useEffect(() => { load(); }, [id]);
  const onRefresh = async () => { setRefreshing(true); await load(); setRefreshing(false); };

  if (!relato) return (
    <View style={{ flex:1, alignItems:'center', justifyContent:'center' }}>
      <Text style={{ fontSize:48 }}>🔍</Text>
      <Text style={[Typography.h3,{color:Colors.gray700}]}>Relato nao encontrado</Text>
      <TouchableOpacity onPress={()=>router.back()}><Text style={[Typography.body,{color:Colors.primaryLight}]}>← Voltar</Text></TouchableOpacity>
    </View>
  );

  return (
    <View style={{ flex:1, backgroundColor:Colors.bg }}>
      <View style={s.header}>
        <TouchableOpacity onPress={()=>router.back()} style={{ padding:Spacing.xs }}><Text style={{ fontSize:24, color:Colors.white }}>←</Text></TouchableOpacity>
        <Text style={[Typography.h4,{color:Colors.white,flex:1}]} numberOfLines={1}>Detalhes do Relato</Text>
        <SyncBadge status={relato.syncStatus} />
      </View>
      <ScrollView contentContainerStyle={{ padding:Spacing.md, paddingBottom:Spacing.xxl }} refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} colors={[Colors.primary]} />}>
        <Card>
          <Text style={[Typography.h3,{color:Colors.gray900,marginBottom:Spacing.sm}]}>{relato.titulo}</Text>
          <View style={{ flexDirection:'row', flexWrap:'wrap', gap:6 }}>
            <Badge label={TIPO_LABELS[relato.tipo]??relato.tipo} color={Colors.primaryLight} />
            <Badge label={GRAVIDADE_LABELS[relato.gravidade]??relato.gravidade} color={GRAVIDADE_COLORS[relato.gravidade]} />
            <Badge label={STATUS_LABELS[relato.status]??relato.status} color={STATUS_COLORS[relato.status]} />
          </View>
        </Card>
        <Card>
          {relato.localDescricao&&<Text style={[Typography.body,{color:Colors.gray700,marginBottom:Spacing.sm}]}>📍 {relato.localDescricao}</Text>}
          {relato.latitude&&<Text style={[Typography.caption,{color:Colors.gray500}]}>🗺️ {relato.latitude.toFixed(6)}, {relato.longitude?.toFixed(6)}</Text>}
          <Text style={[Typography.caption,{color:Colors.gray500,marginTop:4}]}>📅 {new Date(relato.dataOcorrencia).toLocaleString('pt-BR')}</Text>
        </Card>
        <Card>
          <Text style={[Typography.label,{color:Colors.gray500,marginBottom:Spacing.xs,textTransform:'uppercase'}]}>DESCRICAO</Text>
          <Text style={[Typography.body,{color:Colors.gray700,lineHeight:22}]}>{relato.descricao}</Text>
        </Card>
        <View style={{ flexDirection:'row', gap:Spacing.sm }}>
          <TouchableOpacity style={s.actionBtn} onPress={()=>router.push(`/relatos/${id}/evidencias`)}><Text style={s.actionBtnTxt}>📷 Fotos</Text></TouchableOpacity>
          <TouchableOpacity style={s.actionBtn} onPress={()=>router.push(`/relatos/${id}/assinatura`)}><Text style={s.actionBtnTxt}>✍️ Assinar</Text></TouchableOpacity>
        </View>
      </ScrollView>
    </View>
  );
}

const s = StyleSheet.create({
  header:{ backgroundColor:Colors.primary, flexDirection:'row', alignItems:'center', padding:Spacing.md, paddingTop:Spacing.xl+Spacing.sm, gap:Spacing.sm },
  actionBtn:{ flex:1, backgroundColor:Colors.white, borderRadius:Radius.md, padding:Spacing.md, alignItems:'center', ...Shadow.sm },
  actionBtnTxt:{ ...Typography.h4, color:Colors.primary },
});
DETAIL

echo "--- Criando src/app/relatos/[id]/evidencias.tsx ---"
cat > "src/app/relatos/[id]/evidencias.tsx" << 'EVID'
import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, Image, Alert, ActivityIndicator } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import * as ImagePicker from 'expo-image-picker';
import * as FileSystem from 'expo-file-system';
import { EvidenciasRepository, SyncQueueRepository } from '../../../repositories';
import { Button } from '../../../components/ui';
import { Colors, Typography, Spacing, Radius, Shadow } from '../../../constants';
import type { Evidencia } from '../../../types';

export default function EvidenciasScreen() {
  const { id: relatoId } = useLocalSearchParams<{ id:string }>();
  const [evidencias, setEvidencias] = useState<Evidencia[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => { loadEvs(); }, []);
  const loadEvs = async () => { if (relatoId) setEvidencias(await EvidenciasRepository.getByRelatoId(relatoId)); };

  const pick = async (source: 'camera'|'gallery') => {
    const perm = source==='camera' ? await ImagePicker.requestCameraPermissionsAsync() : await ImagePicker.requestMediaLibraryPermissionsAsync();
    if (perm.status!=='granted') { Alert.alert('Permissao necessaria','Permita o acesso nas configuracoes.'); return; }
    const result = source==='camera'
      ? await ImagePicker.launchCameraAsync({ quality:0.85 })
      : await ImagePicker.launchImageLibraryAsync({ allowsMultipleSelection:true, quality:0.85, selectionLimit:5 });
    if (!result.canceled) for (const asset of result.assets) await save(asset);
  };

  const save = async (asset: ImagePicker.ImagePickerAsset) => {
    if (!relatoId) return; setLoading(true);
    try {
      const fn = `ev_${Date.now()}.jpg`;
      const dir = `${FileSystem.documentDirectory}evidencias/${relatoId}/`;
      await FileSystem.makeDirectoryAsync(dir, { intermediates:true });
      const dest = `${dir}${fn}`;
      await FileSystem.copyAsync({ from:asset.uri, to:dest });
      const info = await FileSystem.getInfoAsync(dest, { size:true });
      const ev = await EvidenciasRepository.create({ relatoId, localUri:dest, tipo:'imagem', nomeArquivo:fn, tamanhoBytes:(info as any).size, mimeType:'image/jpeg', capturedAt:new Date().toISOString() });
      await SyncQueueRepository.add({ tipo:'upload', entidade:'evidencia', entidadeId:ev.id, clientId:ev.clientId, payload:{ relatoId, evidenciaId:ev.id, localUri:dest } });
      await loadEvs();
    } catch (err:any) { Alert.alert('Erro',err.message); }
    finally { setLoading(false); }
  };

  return (
    <View style={{ flex:1, backgroundColor:Colors.bg }}>
      <View style={s.header}>
        <TouchableOpacity onPress={()=>router.back()} style={{ padding:Spacing.xs }}><Text style={{ fontSize:24, color:Colors.white }}>←</Text></TouchableOpacity>
        <Text style={[Typography.h3,{color:Colors.white,flex:1,textAlign:'center'}]}>Evidencias</Text>
        <View style={{ width:36 }} />
      </View>
      <ScrollView contentContainerStyle={{ padding:Spacing.md, paddingBottom:Spacing.xxl }}>
        <View style={{ flexDirection:'row', gap:Spacing.md, marginBottom:Spacing.md }}>
          {[{icon:'📷',label:'Camera',src:'camera'},{icon:'🖼️',label:'Galeria',src:'gallery'}].map(b=>(
            <TouchableOpacity key={b.src} style={s.captureBtn} onPress={()=>pick(b.src as any)}>
              <Text style={{ fontSize:36, marginBottom:4 }}>{b.icon}</Text>
              <Text style={[Typography.h4,{color:Colors.primary}]}>{b.label}</Text>
            </TouchableOpacity>
          ))}
        </View>
        {loading&&<View style={{ flexDirection:'row', gap:8, alignItems:'center', justifyContent:'center', marginBottom:Spacing.md }}><ActivityIndicator color={Colors.primary} /><Text style={[Typography.body,{color:Colors.primary}]}>Salvando...</Text></View>}
        <Text style={[Typography.caption,{color:Colors.gray500,textAlign:'center',marginBottom:Spacing.md}]}>{evidencias.length} evidencia(s) salva(s)</Text>
        <View style={{ flexDirection:'row', flexWrap:'wrap', gap:Spacing.sm }}>
          {evidencias.map(ev=>(
            <TouchableOpacity key={ev.clientId} style={s.thumb} onLongPress={()=>{ Alert.alert('Remover','Deseja remover?',[{text:'Cancelar',style:'cancel'},{text:'Remover',style:'destructive',onPress:async()=>{ await EvidenciasRepository.remove(ev.clientId); await loadEvs(); }}]); }}>
              <Image source={{ uri:ev.localUri }} style={{ width:'100%', height:'100%' }} resizeMode="cover" />
            </TouchableOpacity>
          ))}
        </View>
        <Button label="Ir para Assinatura →" variant="secondary" onPress={()=>router.push(`/relatos/${relatoId}/assinatura`)} style={{ marginTop:Spacing.lg }} />
        <Button label="Concluir" onPress={()=>router.replace(`/relatos/${relatoId}`)} style={{ marginTop:Spacing.sm }} />
      </ScrollView>
    </View>
  );
}

const s = StyleSheet.create({
  header:{ backgroundColor:Colors.primary, flexDirection:'row', alignItems:'center', padding:Spacing.md, paddingTop:Spacing.xl+Spacing.sm },
  captureBtn:{ flex:1, backgroundColor:Colors.white, borderRadius:Radius.lg, padding:Spacing.lg, alignItems:'center', ...Shadow.sm, borderWidth:2, borderColor:Colors.border },
  thumb:{ width:'47%', aspectRatio:1, borderRadius:Radius.md, overflow:'hidden', backgroundColor:Colors.gray200 },
});
EVID

echo "--- Criando src/app/relatos/[id]/assinatura.tsx ---"
cat > "src/app/relatos/[id]/assinatura.tsx" << 'ASSIN'
import React, { useRef, useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Alert, ScrollView, ActivityIndicator } from 'react-native';
import { router, useLocalSearchParams } from 'expo-router';
import SignatureCanvas from 'react-native-signature-canvas';
import * as FileSystem from 'expo-file-system';
import * as Location from 'expo-location';
import { AssinaturasRepository, SyncQueueRepository } from '../../../repositories';
import { Button, Input } from '../../../components/ui';
import { Colors, Typography, Spacing, Radius, Shadow } from '../../../constants';

export default function AssinaturaScreen() {
  const { id: relatoId } = useLocalSearchParams<{ id:string }>();
  const signRef = useRef<any>(null);
  const [nome, setNome] = useState('');
  const [cargo, setCargo] = useState('');
  const [hasSig, setHasSig] = useState(false);
  const [saving, setSaving] = useState(false);

  const handleOK = async (sig: string) => {
    if (!relatoId||!nome.trim()) { Alert.alert('Nome obrigatorio','Informe o nome do assinante.'); return; }
    setSaving(true);
    try {
      let lat: number|undefined; let lon: number|undefined;
      try { const { status } = await Location.requestForegroundPermissionsAsync(); if (status==='granted') { const loc = await Location.getCurrentPositionAsync({ accuracy:Location.Accuracy.Low }); lat=loc.coords.latitude; lon=loc.coords.longitude; } } catch {}
      const dir = `${FileSystem.documentDirectory}assinaturas/${relatoId}/`;
      await FileSystem.makeDirectoryAsync(dir, { intermediates:true });
      const fn = `assinatura_${Date.now()}.png`;
      const dest = `${dir}${fn}`;
      await FileSystem.writeAsStringAsync(dest, sig.replace(/^data:image\/png;base64,/,''), { encoding:FileSystem.EncodingType.Base64 });
      const asn = await AssinaturasRepository.create({ relatoId, assinanteNome:nome.trim(), assinanteCargo:cargo.trim()||undefined, localUri:dest, latitude:lat, longitude:lon });
      await SyncQueueRepository.add({ tipo:'upload', entidade:'assinatura', entidadeId:asn.id, clientId:asn.clientId, payload:{ relatoId, assinaturaId:asn.id, assinanteNome:asn.assinanteNome, assinaturaBase64:sig, latitude:lat, longitude:lon } });
      Alert.alert('Assinatura salva!','Registrada e sera enviada na sincronizacao.',[{ text:'Ver relato', onPress:()=>router.replace(`/relatos/${relatoId}`) }]);
    } catch (err:any) { Alert.alert('Erro',err.message); }
    finally { setSaving(false); }
  };

  return (
    <View style={{ flex:1, backgroundColor:Colors.bg }}>
      <View style={s.header}>
        <TouchableOpacity onPress={()=>router.back()} style={{ padding:Spacing.xs }}><Text style={{ fontSize:24, color:Colors.white }}>←</Text></TouchableOpacity>
        <Text style={[Typography.h3,{color:Colors.white,flex:1,textAlign:'center'}]}>Assinatura Digital</Text>
        <View style={{ width:36 }} />
      </View>
      <ScrollView contentContainerStyle={{ padding:Spacing.md, paddingBottom:Spacing.xxl }} keyboardShouldPersistTaps="handled">
        <View style={s.section}>
          <Text style={s.sectionTitle}>Dados do assinante</Text>
          <Input label="Nome completo" required placeholder="Joao da Silva" value={nome} onChangeText={setNome} />
          <Input label="Cargo / Funcao" placeholder="Tecnico de Seguranca" value={cargo} onChangeText={setCargo} />
        </View>
        <View style={s.section}>
          <Text style={s.sectionTitle}>Assinatura</Text>
          <Text style={[Typography.caption,{color:Colors.gray500,marginBottom:Spacing.sm}]}>Assine com o dedo no campo abaixo:</Text>
          <View style={{ borderWidth:2, borderColor:Colors.border, borderRadius:Radius.md, overflow:'hidden', height:200, backgroundColor:Colors.white }}>
            <SignatureCanvas ref={signRef} onOK={handleOK} onEmpty={()=>Alert.alert('Assinatura vazia','Assine antes de salvar.')} onBegin={()=>setHasSig(true)}
              webStyle={`.m-signature-pad{border:none}.m-signature-pad--footer{display:none}body{margin:0}`}
              backgroundColor="white" penColor={Colors.primary} style={{ height:200, width:'100%' }} />
          </View>
          <View style={{ flexDirection:'row', justifyContent:'space-between', alignItems:'center', marginTop:Spacing.sm }}>
            <TouchableOpacity style={s.clearBtn} onPress={()=>{ signRef.current?.clearSignature(); setHasSig(false); }}><Text style={[Typography.caption,{color:Colors.gray700,fontWeight:'600'}]}>🔄 Limpar</Text></TouchableOpacity>
            <Text style={[Typography.caption,{color:Colors.gray500,fontStyle:'italic'}]}>{hasSig?'✓ Capturada':'Aguardando...'}</Text>
          </View>
        </View>
        {saving ? <View style={{ flexDirection:'row', gap:8, alignItems:'center', justifyContent:'center', padding:Spacing.md }}><ActivityIndicator color={Colors.primary} /><Text style={[Typography.body,{color:Colors.primary}]}>Salvando...</Text></View>
          : <Button label="Salvar Assinatura" onPress={()=>signRef.current?.readSignature()} size="lg" disabled={!hasSig||!nome.trim()} style={{ marginTop:Spacing.md }} />}
        <Button label="Pular assinatura" variant="ghost" onPress={()=>router.replace(`/relatos/${relatoId}`)} style={{ marginTop:Spacing.sm }} />
      </ScrollView>
    </View>
  );
}

const s = StyleSheet.create({
  header:{ backgroundColor:Colors.primary, flexDirection:'row', alignItems:'center', padding:Spacing.md, paddingTop:Spacing.xl+Spacing.sm },
  section:{ backgroundColor:Colors.white, borderRadius:Radius.lg, padding:Spacing.md, marginBottom:Spacing.md, ...Shadow.sm },
  sectionTitle:{ ...Typography.h4, color:Colors.gray900, marginBottom:Spacing.md },
  clearBtn:{ paddingHorizontal:Spacing.md, paddingVertical:Spacing.xs, borderRadius:Radius.sm, borderWidth:1, borderColor:Colors.border },
});
ASSIN

echo ""
echo "=== Instalando dependencias ==="
npm install --legacy-peer-deps 2>&1 | tail -5

echo ""
echo "=== Iniciando build EAS Android ==="
EXPO_TOKEN=XcVbECF7kqYJ8B9nNCm2qPiDoc2uIs5bP6dSDEG9 eas build --platform android --profile preview --non-interactive

echo ""
echo "=== CONCLUIDO ==="
