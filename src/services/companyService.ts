import { supabase } from './supabase';

export interface Company {
  id: string; nome: string; nome_fantasia?: string; cnpj?: string;
  logo_url?: string; segmento?: string; plano: string; status: string;
}
export interface UserCompany {
  company_id: string; role: string; status: string; company: Company;
}

export const CompanyService = {
  async minhasEmpresas(): Promise<UserCompany[]> {
    const { data, error } = await supabase
      .from('user_companies')
      .select('company_id,role,status,company:companies(id,nome,nome_fantasia,cnpj,logo_url,segmento,plano,status)')
      .eq('status', 'ativo');
    if (error) throw error;
    return (data || []) as any[];
  },

  async usarConvite(codigo: string) {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) throw new Error('Não autenticado.');
    const { data, error } = await supabase.rpc('usar_convite', {
      p_codigo: codigo.toUpperCase().trim(),
      p_user_id: user.id,
    });
    if (error) throw error;
    return data as any;
  },

  async cadastrarEmpresa(dados: { nome: string; cnpj?: string; segmento?: string }) {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) throw new Error('Não autenticado.');
    const { data: company, error } = await supabase
      .from('companies')
      .insert({ nome: dados.nome, cnpj: dados.cnpj || null, segmento: dados.segmento || null, status: 'ativo', plano: 'trial' })
      .select().single();
    if (error) throw error;
    await supabase.from('user_companies').insert({ user_id: user.id, company_id: company.id, role: 'admin', status: 'ativo' });
    return company as Company;
  },

  async gerarConvite(companyId: string, role = 'tecnico', dias = 30) {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) throw new Error('Não autenticado.');
cat > sst-mobile/src/services/dataService.ts << 'EOF'
import { supabase } from './supabase';

async function userId(): Promise<string> {
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) throw new Error('Não autenticado.');
  return user.id;
}

function makeCrud<T extends { id?: string; company_id: string }>(tabela: string) {
  return {
    async listar(companyId: string): Promise<T[]> {
      const { data, error } = await supabase.from(tabela).select('*')
        .eq('company_id', companyId).is('deleted_at', null)
        .order('created_at', { ascending: false });
      if (error) throw error;
      return (data || []) as T[];
    },
    async criar(item: T): Promise<T> {
      const uid = await userId();
      const { data, error } = await supabase.from(tabela)
        .insert({ ...item, created_by: uid }).select().single();
      if (error) throw error;
      return data as T;
    },
    async atualizar(id: string, changes: Partial<T>): Promise<T> {
      const { data, error } = await supabase.from(tabela)
        .update({ ...changes, updated_at: new Date().toISOString() } as any)
        .eq('id', id).select().single();
      if (error) throw error;
      return data as T;
    },
    async excluir(id: string): Promise<void> {
      const { error } = await supabase.from(tabela)
        .update({ deleted_at: new Date().toISOString() } as any).eq('id', id);
      if (error) throw error;
    },
  };
}

export const RelatoService  = makeCrud<any>('relatos');
export const AsoService     = makeCrud<any>('asos');
export const EpiService     = makeCrud<any>('epis');
export const DdsService     = makeCrud<any>('dds');
export const AgenteService  = makeCrud<any>('agentes');
export const AcaoService    = makeCrud<any>('acoes');

export const DashboardService = {
  async kpis(companyId: string) {
    const [relatos, asos, dds, acoes, epis, agentes] = await Promise.all([
      supabase.from('relatos').select('tipo,status').eq('company_id', companyId).is('deleted_at', null),
      supabase.from('asos').select('validade').eq('company_id', companyId).is('deleted_at', null),
      supabase.from('dds').select('id', { count: 'exact' }).eq('company_id', companyId).is('deleted_at', null),
      supabase.from('acoes').select('status').eq('company_id', companyId).is('deleted_at', null),
      supabase.from('epis').select('id', { count: 'exact' }).eq('company_id', companyId).is('deleted_at', null),
      supabase.from('agentes').select('id', { count: 'exact' }).eq('company_id', companyId).is('deleted_at', null),
    ]);
    const r = relatos.data || []; const a = asos.data || []; const ac = acoes.data || [];
    return {
      fator_humano:    r.filter((x:any) => x.tipo === 'fator_humano').length,
      perigo:          r.filter((x:any) => x.tipo === 'perigo').length,
      comportamento:   r.filter((x:any) => x.tipo === 'comportamento').length,
      total_relatos:   r.length,
      total_dds:       dds.count || 0,
      acoes_pendentes: ac.filter((x:any) => x.status === 'Pendente').length,
      total_epis:      epis.count || 0,
      total_agentes:   agentes.count || 0,
      aso_vencidos:    a.filter((x:any) => x.validade && new Date(x.validade) < new Date()).length,
      aso_vencendo:    a.filter((x:any) => { if(!x.validade) return false; const d=Math.ceil((new Date(x.validade).getTime()-Date.now())/86400000); return d>=0&&d<=30; }).length,
    };
  },
};
