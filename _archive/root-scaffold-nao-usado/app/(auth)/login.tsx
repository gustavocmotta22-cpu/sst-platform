import { useState } from 'react';
import {
  View, Text, TextInput, TouchableOpacity,
  StyleSheet, ActivityIndicator, Alert, KeyboardAvoidingView, Platform, ScrollView,
} from 'react-native';
import { router } from 'expo-router';
import { AuthService } from '@/services';
import { colors, typography, spacing, radius } from '@/theme';

export default function LoginScreen() {
  const [email, setEmail]       = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading]   = useState(false);

  async function handleLogin() {
    if (!email || !password) {
      Alert.alert('Atenção', 'Preencha e-mail e senha.');
      return;
    }
    setLoading(true);
    try {
      await AuthService.signIn(email, password);
      router.replace('/(app)/(tabs)/inicio');
    } catch (e: any) {
      Alert.alert('Erro', e.message || 'Credenciais inválidas.');
    } finally {
      setLoading(false);
    }
  }

  return (
    <KeyboardAvoidingView style={s.root} behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
      <ScrollView contentContainerStyle={s.scroll} keyboardShouldPersistTaps="handled">
        {/* Header verde */}
        <View style={s.header}>
          <View style={s.logoBox}>
            <Text style={s.logoIcon}>🛡</Text>
          </View>
          <Text style={s.logoTitle}>SegTrab</Text>
          <Text style={s.logoSub}>DT 22:8</Text>
          <Text style={s.headerDesc}>Sistema de Gestão SST</Text>
        </View>

        {/* Formulário */}
        <View style={s.form}>
          <Text style={s.formTitle}>Acesse sua conta</Text>

          <Text style={s.label}>E-mail</Text>
          <TextInput
            style={s.input}
            value={email}
            onChangeText={setEmail}
            keyboardType="email-address"
            autoCapitalize="none"
            placeholder="seu@email.com"
            placeholderTextColor={colors.gray[400]}
          />

          <Text style={s.label}>Senha</Text>
          <TextInput
            style={s.input}
            value={password}
            onChangeText={setPassword}
            secureTextEntry
            placeholder="Sua senha"
            placeholderTextColor={colors.gray[400]}
          />

          <TouchableOpacity style={s.btn} onPress={handleLogin} disabled={loading}>
            {loading
              ? <ActivityIndicator color={colors.white} />
              : <Text style={s.btnText}>ENTRAR</Text>
            }
          </TouchableOpacity>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const s = StyleSheet.create({
  root:       { flex: 1, backgroundColor: colors.gray[50] },
  scroll:     { flexGrow: 1 },
  header:     { backgroundColor: colors.green[800], padding: spacing[6], alignItems: 'center', paddingTop: 60 },
  logoBox:    { width: 64, height: 64, borderRadius: radius.xl, backgroundColor: 'rgba(255,255,255,0.15)', alignItems: 'center', justifyContent: 'center', marginBottom: spacing[3] },
  logoIcon:   { fontSize: 32 },
  logoTitle:  { fontSize: typography.sizes['4xl'], fontWeight: typography.weights.black, color: colors.white },
  logoSub:    { fontSize: typography.sizes.xs, color: 'rgba(255,255,255,0.6)', letterSpacing: 3, marginTop: 2 },
  headerDesc: { fontSize: typography.sizes.sm, color: 'rgba(255,255,255,0.75)', marginTop: spacing[2] },
  form:       { padding: spacing[6], paddingTop: spacing[8] },
  formTitle:  { fontSize: typography.sizes.xl, fontWeight: typography.weights.bold, color: colors.gray[900], marginBottom: spacing[6] },
  label:      { fontSize: typography.sizes.sm, fontWeight: typography.weights.semibold, color: colors.gray[700], marginBottom: spacing[1] },
  input:      { height: 52, borderRadius: radius.lg, borderWidth: 1.5, borderColor: colors.gray[200], backgroundColor: colors.white, paddingHorizontal: spacing[4], fontSize: typography.sizes.md, color: colors.gray[900], marginBottom: spacing[4] },
  btn:        { height: 52, borderRadius: radius.lg, backgroundColor: colors.green[700], alignItems: 'center', justifyContent: 'center', marginTop: spacing[2] },
  btnText:    { fontSize: typography.sizes.md, fontWeight: typography.weights.bold, color: colors.white, letterSpacing: 1 },
});
