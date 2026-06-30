import { View, Text, ScrollView, StyleSheet, TouchableOpacity } from 'react-native';
import { useAuthStore } from '@/stores';
import { AuthService } from '@/services';
import { router } from 'expo-router';
import { colors, typography, spacing, radius } from '@/theme';

export default function InicioScreen() {
  const { user, logout } = useAuthStore();

  async function handleLogout() {
    await AuthService.signOut();
    logout();
    router.replace('/(auth)/login');
  }

  return (
    <View style={s.root}>
      {/* Header */}
      <View style={s.header}>
        <View>
          <Text style={s.headerSub}>Bem-vindo,</Text>
          <Text style={s.headerName}>{user?.nome ?? 'Usuário'}</Text>
        </View>
        <TouchableOpacity style={s.logoutBtn} onPress={handleLogout}>
          <Text style={s.logoutTxt}>Sair</Text>
        </TouchableOpacity>
      </View>

      <ScrollView style={s.scroll} contentContainerStyle={{ padding: spacing[4] }}>
        {/* KPIs */}
        <Text style={s.sectionLabel}>INDICADORES</Text>
        <View style={s.grid}>
          {[
            { label: 'Relatos',     value: '0', color: colors.green[700] },
            { label: 'Ações',       value: '0', color: colors.yellow[700] },
            { label: 'Acidentes',   value: '0', color: colors.red[700] },
            { label: 'Treinamentos',value: '0', color: colors.blue[700] },
          ].map((k) => (
            <View key={k.label} style={s.kpi}>
              <Text style={[s.kpiVal, { color: k.color }]}>{k.value}</Text>
              <Text style={s.kpiLabel}>{k.label}</Text>
            </View>
          ))}
        </View>

        {/* Módulos */}
        <Text style={[s.sectionLabel, { marginTop: spacing[6] }]}>MÓDULOS</Text>
        {[
          { label: '⚠  Relatos de Campo',   route: '/(app)/(tabs)/relatos' },
          { label: '🦺  Fichas de EPI',      route: '/(app)/(tabs)/epi' },
          { label: '📋  DDS / Treinamentos', route: '/(app)/(tabs)/dds' },
          { label: '🤖  Assistente NR',      route: '/(app)/(tabs)/assistente' },
        ].map((m) => (
          <TouchableOpacity
            key={m.label}
            style={s.modCard}
            onPress={() => router.push(m.route as any)}
          >
            <Text style={s.modLabel}>{m.label}</Text>
            <Text style={s.modArrow}>›</Text>
          </TouchableOpacity>
        ))}
      </ScrollView>
    </View>
  );
}

const s = StyleSheet.create({
  root:       { flex: 1, backgroundColor: colors.gray[50] },
  header:     { backgroundColor: colors.green[800], paddingTop: 52, paddingBottom: spacing[5], paddingHorizontal: spacing[5], flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-end' },
  headerSub:  { fontSize: typography.sizes.sm, color: 'rgba(255,255,255,0.7)' },
  headerName: { fontSize: typography.sizes.xl, fontWeight: typography.weights.bold, color: colors.white },
  logoutBtn:  { paddingHorizontal: spacing[3], paddingVertical: spacing[1], borderRadius: radius.sm, backgroundColor: 'rgba(255,255,255,0.15)' },
  logoutTxt:  { fontSize: typography.sizes.sm, color: colors.white, fontWeight: typography.weights.semibold },
  scroll:     { flex: 1 },
  sectionLabel: { fontSize: typography.sizes.xs, fontWeight: typography.weights.bold, color: colors.gray[500], letterSpacing: 1.5, marginBottom: spacing[3], textTransform: 'uppercase' },
  grid:       { flexDirection: 'row', flexWrap: 'wrap', gap: spacing[3] },
  kpi:        { flex: 1, minWidth: '45%', backgroundColor: colors.white, borderRadius: radius.lg, padding: spacing[4], alignItems: 'center' },
  kpiVal:     { fontSize: typography.sizes['3xl'], fontWeight: typography.weights.black },
  kpiLabel:   { fontSize: typography.sizes.xs, color: colors.gray[500], marginTop: spacing[1] },
  modCard:    { backgroundColor: colors.white, borderRadius: radius.lg, padding: spacing[4], marginBottom: spacing[3], flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  modLabel:   { fontSize: typography.sizes.md, fontWeight: typography.weights.semibold, color: colors.gray[800] },
  modArrow:   { fontSize: 22, color: colors.green[700] },
});
