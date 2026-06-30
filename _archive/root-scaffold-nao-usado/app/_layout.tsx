import { useEffect } from 'react';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { useAuthStore } from '@/stores';
import { AuthService } from '@/services';

export default function RootLayout() {
  const { setUser, setSession, setLoading } = useAuthStore();

  useEffect(() => {
    AuthService.getSession().then(async (session) => {
      if (session) {
        setSession(session as any);
        const profile = await AuthService.getProfile(session.user.id);
        setUser(profile);
      }
      setLoading(false);
    });

    const { data: listener } = AuthService.onAuthStateChange(
      async (event, session) => {
        if (session && typeof session === 'object' && 'user' in session) {
          const s = session as any;
          setSession(s);
          const profile = await AuthService.getProfile(s.user.id);
          setUser(profile);
        } else {
          setUser(null);
          setSession(null);
        }
cat > app/index.tsx << 'EOF'
import { Redirect } from 'expo-router';
import { useAuthStore } from '@/stores';
import { ActivityIndicator, View } from 'react-native';

export default function Index() {
  const { isAuthenticated, isLoading } = useAuthStore();

  if (isLoading) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: '#0E5E2D' }}>
        <ActivityIndicator size="large" color="#ffffff" />
      </View>
    );
  }

  return <Redirect href={isAuthenticated ? '/(app)/(tabs)/inicio' : '/(auth)/login'} />;
}
