import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, TouchableOpacity, ScrollView, StyleSheet, ActivityIndicator, Alert } from 'react-native';
import { CompanyService } from '../services/companyService';

const C = { navy:'#0F1C2E', blue:'#1E6FD9', green:'#16A34A', greenBg:'#F0FDF4', orange:'#EA580C', red:'#DC2626', redBg:'#FEF2F2', bg:'#F1F5F9', card:'#FFFFFF', border:'#E2E8F0', muted:'#64748B', text:'#0F172A', textLight:'#94A3B8', white:'#FFFFFF' };

export default function EmpresaSelector({ onSelecionada }: { onSelecionada: (company: any, role: string) => void }) {
  const [aba, setAba] = useState<'minhas'|'convite'|'nova'>('minhas');
  const [minhas, setMinhas] = useState<any[]>([]);
  const [busca, setBusca] = useState('');
  const [loading, setLoading] = useState(true);
  const [erro, setErro] = useState('');
  const [codigo, setCodigo] = useState('');
  const [loadingConvite, setLoadingConvite] = useState(false);
  const [nomeEmpresa, setNomeEmpresa] = useState('');
  const [cnpj, setCnpj] = useState('');
  const [segmento, setSegmento] = useState('');
  const [loadingNova, setLoadingNova] = useState(false);

  useEffect(() => { carregar(); }, []);

  async function carregar() {
    setLoading(true);
    try { setMinhas(await CompanyService.minhasEmpresas()); }
    catch (e: any) { setErro(e.message); }
    setLoading(false);
  }

  const filtradas = minhas.filter(uc =>
    uc.company.nome.toLowerCase().includes(busca.toLowerCase()) ||
    (uc.company.cnpj || '').includes(busca)
  );

  async function usarConvite() {
    if (!codigo.trim()) { Alert.alert('Atenção', 'Digite o código de convite.'); return; }
    setLoadingConvite(true); setErro('');
    try {
      const res = await CompanyService.usarConvite(codigo);
      if (!res.ok) { setErro(res.erro || 'Código inválido.'); }
      else {
        Alert.alert('Acesso liberado!', `Você agora tem acesso à empresa ${res.company_nome}.`, [
          { text: 'Entrar', onPress: () => onSelecionada({ id: res.company_id, nome: res.company_nome, logo_url: res.company_logo, cnpj: res.company_cnpj, plano: 'trial', status: 'ativo' }, res.role || 'tecnico') }
        ]);
        carregar();
      }
    } catch (e: any) { setErro(e.message); }
    setLoadingConvite(false);
  }

  async function cadastrarEmpresa() {
    if (!nomeEmpresa.trim()) { Alert.alert('Atenção', 'Informe o nome da empresa.'); return; }
    setLoadingNova(true); setErro('');
    try {
      const company = await CompanyService.cadastrarEmpresa({ nome: nomeEmpresa, cnpj, segmento });
      Alert.alert('Empresa criada!', `${company.nome} foi cadastrada. Você é o administrador.`, [
        { text: 'Entrar', onPress: () => onSelecionada(company, 'admin') }
      ]);
    } catch (e: any) { setErro(e.message); }
    setLoadingNova(false);
  }

  const SEGS = ['Construção Civil','Indústria','Alimentação','Logística','Saúde','Consultoria SST','Outro'];

  return (
    <View style={s.root}>
      <View style={s.header}>
        <View style={s.logoBox}><Text style={{fontSize:18}}>🛡</Text></View>
        <View style={{marginLeft:10}}><Text style={{color:C.white,fontWeight:'900',fontSize:17}}><Text style={{color:'#22C55E'}}>SEG</Text>TRAB</Text><Text style={{color:'rgba(255,255,255,0.5)',fontSize:10,letterSpacing:2}}>DT 22:8</Text></View>
      </View>
      <View style={{backgroundColor:C.navy,paddingHorizontal:18,paddingBottom:14}}>
        <Text style={{color:C.white,fontSize:18,fontWeight:'900'}}>Selecione a empresa</Text>
        <Text style={{color:'rgba(255,255,255,0.55)',fontSize:12,marginTop:2}}>Escolha onde deseja inserir dados SST</Text>
      </View>
      <View style={s.abas}>
        {([{id:'minhas',label:'Minhas empresas'},{id:'convite',label:'Código de convite'},{id:'nova',label:'+ Cadastrar'}] as const).map(a=>(
          <TouchableOpacity key={a.id} onPress={()=>{setAba(a.id);setErro('');}} style={[s.aba,aba===a.id&&s.abaOn]}>
            <Text style={[s.abaTxt,aba===a.id&&{color:C.white,fontWeight:'800'}]}>{a.label}</Text>
          </TouchableOpacity>
        ))}
      </View>
      {erro?<View style={s.erroBox}><Text style={{color:C.red,fontSize:13}}>{erro}</Text></View>:null}
      <ScrollView style={{flex:1}} contentContainerStyle={{padding:16,paddingBottom:40}}>

        {aba==='minhas'&&(
          <View>
            <View style={s.searchBox}>
              <Text style={{fontSize:16,marginRight:8}}>🔍</Text>
              <TextInput style={{flex:1,fontSize:14,color:C.text}} value={busca} onChangeText={setBusca} placeholder="Buscar por nome ou CNPJ..." placeholderTextColor={C.textLight}/>
              {busca.length>0&&<TouchableOpacity onPress={()=>setBusca('')}><Text style={{color:C.muted,fontSize:18,marginLeft:8}}>✕</Text></TouchableOpacity>}
            </View>
            {loading?<ActivityIndicator color={C.blue} style={{marginTop:40}}/>
            :filtradas.length===0?(
              <View style={{alignItems:'center',padding:40}}>
                <Text style={{fontSize:36,marginBottom:12}}>🏢</Text>
                <Text style={{fontWeight:'700',color:C.text,fontSize:15,marginBottom:6}}>{busca?'Nenhuma empresa encontrada':'Nenhuma empresa vinculada'}</Text>
                <Text style={{color:C.muted,fontSize:13,textAlign:'center',lineHeight:20,marginBottom:16}}>{busca?`Nenhuma empresa com "${busca}".\nTente outro nome.`:'Use um código de convite\nou cadastre sua empresa.'}</Text>
                <TouchableOpacity onPress={()=>setAba('convite')} style={{backgroundColor:C.blue,borderRadius:10,paddingHorizontal:20,paddingVertical:10}}>
                  <Text style={{color:C.white,fontWeight:'700'}}>Tenho um código de convite</Text>
                </TouchableOpacity>
              </View>
            ):filtradas.map(uc=>(
              <TouchableOpacity key={uc.company_id} onPress={()=>onSelecionada(uc.company,uc.role)} style={s.card}>
                <View style={s.avatar}><Text style={{color:C.white,fontWeight:'900',fontSize:16}}>{uc.company.nome[0].toUpperCase()}</Text></View>
                <View style={{flex:1,marginLeft:12}}>
                  <Text style={{fontSize:15,fontWeight:'700',color:C.text}}>{uc.company.nome}</Text>
                  {uc.company.cnpj&&<Text style={{fontSize:12,color:C.muted,marginTop:1}}>CNPJ: {uc.company.cnpj}</Text>}
                  {uc.company.segmento&&<Text style={{fontSize:12,color:C.muted}}>{uc.company.segmento}</Text>}
                </View>
                <View style={{alignItems:'flex-end',gap:4}}>
                  <View style={{backgroundColor:uc.role==='admin'?'#EFF6FF':'#F5F3FF',borderRadius:6,paddingHorizontal:8,paddingVertical:3}}>
                    <Text style={{fontSize:11,fontWeight:'700',color:uc.role==='admin'?C.blue:'#7C3AED'}}>{uc.role==='admin'?'Admin':uc.role==='gestor'?'Gestor':'Técnico'}</Text>
                  </View>
                  <View style={{backgroundColor:uc.company.plano==='trial'?'#FFF7ED':'#F0FDF4',borderRadius:6,paddingHorizontal:8,paddingVertical:3}}>
                    <Text style={{fontSize:10,fontWeight:'700',color:uc.company.plano==='trial'?C.orange:C.green}}>{uc.company.plano.toUpperCase()}</Text>
                  </View>
                </View>
                <Text style={{color:C.muted,fontSize:20,marginLeft:8}}>›</Text>
              </TouchableOpacity>
            ))}
          </View>
        )}

        {aba==='convite'&&(
          <View style={s.formCard}>
            <Text style={{fontSize:28,textAlign:'center',marginBottom:10}}>🔑</Text>
            <Text style={{fontSize:16,fontWeight:'800',color:C.text,textAlign:'center',marginBottom:4}}>Código de convite</Text>
            <Text style={{fontSize:13,color:C.muted,textAlign:'center',lineHeight:20,marginBottom:18}}>Solicite o código ao administrador da empresa.{'\n'}Formato: XXX-XXX-XXXX</Text>
            <Text style={s.label}>Código de acesso</Text>
            <TextInput style={[s.input,{textAlign:'center',letterSpacing:4,fontSize:18,fontWeight:'700'}]} value={codigo} onChangeText={v=>setCodigo(v.toUpperCase())} placeholder="XXX-XXX-XXXX" placeholderTextColor={C.textLight} autoCapitalize="characters" maxLength={12}/>
            <View style={{backgroundColor:'#FFF7ED',borderRadius:10,padding:12,marginBottom:14,borderLeftWidth:3,borderLeftColor:C.orange}}>
              <Text style={{fontSize:12,color:'#92400E',lineHeight:18}}>🔒 Código validado uma única vez. Após usar, você fica vinculado à empresa automaticamente.</Text>
            </View>
            <TouchableOpacity onPress={usarConvite} disabled={loadingConvite} style={[s.btnPrimary,{opacity:loadingConvite?.7:1}]}>
              {loadingConvite?<ActivityIndicator color={C.white}/>:<Text style={s.btnTxt}>Validar e entrar</Text>}
            </TouchableOpacity>
          </View>
        )}

        {aba==='nova'&&(
          <View style={s.formCard}>
            <Text style={{fontSize:28,textAlign:'center',marginBottom:10}}>🏢</Text>
            <Text style={{fontSize:16,fontWeight:'800',color:C.text,textAlign:'center',marginBottom:4}}>Cadastrar nova empresa</Text>
            <Text style={{fontSize:13,color:C.muted,textAlign:'center',lineHeight:20,marginBottom:18}}>Você será o administrador e poderá convidar membros.</Text>
            <Text style={s.label}>Nome da empresa *</Text>
            <TextInput style={s.input} value={nomeEmpresa} onChangeText={setNomeEmpresa} placeholder="Ex: Construções XYZ Ltda" placeholderTextColor={C.textLight}/>
            <Text style={s.label}>CNPJ</Text>
            <TextInput style={s.input} value={cnpj} onChangeText={setCnpj} placeholder="00.000.000/0001-00" placeholderTextColor={C.textLight} keyboardType="numeric"/>
            <Text style={s.label}>Segmento</Text>
            <ScrollView horizontal showsHorizontalScrollIndicator={false} style={{marginBottom:16}}>
              <View style={{flexDirection:'row',gap:8}}>
                {SEGS.map(sg=>(
                  <TouchableOpacity key={sg} onPress={()=>setSegmento(sg)} style={{backgroundColor:segmento===sg?C.blue:'#F1F5F9',borderRadius:8,paddingHorizontal:12,paddingVertical:7,borderWidth:1,borderColor:segmento===sg?C.blue:C.border}}>
                    <Text style={{color:segmento===sg?C.white:C.text,fontSize:12,fontWeight:'600'}}>{sg}</Text>
                  </TouchableOpacity>
                ))}
              </View>
            </ScrollView>
            <View style={{backgroundColor:C.greenBg,borderRadius:10,padding:12,marginBottom:14,borderLeftWidth:3,borderLeftColor:C.green}}>
              <Text style={{fontSize:12,color:'#166534',lineHeight:18}}>📋 Após cadastrar, acesse Configurações para adicionar a logomarca. Ela aparecerá em todos os documentos.</Text>
            </View>
            <TouchableOpacity onPress={cadastrarEmpresa} disabled={loadingNova} style={[s.btnPrimary,{backgroundColor:C.green,opacity:loadingNova?.7:1}]}>
              {loadingNova?<ActivityIndicator color={C.white}/>:<Text style={s.btnTxt}>Cadastrar empresa</Text>}
            </TouchableOpacity>
          </View>
        )}
      </ScrollView>
    </View>
  );
}

const s = StyleSheet.create({
  root:{flex:1,backgroundColor:'#F1F5F9'},
  header:{backgroundColor:'#0F1C2E',flexDirection:'row',alignItems:'center',padding:18,paddingTop:52},
  logoBox:{width:34,height:34,borderRadius:10,backgroundColor:'#16A34A',alignItems:'center',justifyContent:'center'},
  abas:{flexDirection:'row',backgroundColor:'#0F1C2E',borderTopWidth:1,borderTopColor:'rgba(255,255,255,0.1)'},
  aba:{flex:1,paddingVertical:11,alignItems:'center'},
  abaOn:{borderBottomWidth:3,borderBottomColor:'#22C55E'},
  abaTxt:{color:'rgba(255,255,255,0.5)',fontSize:12,fontWeight:'600'},
  erroBox:{backgroundColor:'#FEF2F2',padding:12,marginHorizontal:16,marginTop:8,borderRadius:10,borderLeftWidth:3,borderLeftColor:'#DC2626'},
  searchBox:{flexDirection:'row',alignItems:'center',backgroundColor:'#fff',borderRadius:12,paddingHorizontal:14,height:48,marginBottom:14,borderWidth:1.5,borderColor:'#E2E8F0'},
  card:{backgroundColor:'#fff',borderRadius:14,padding:14,marginBottom:10,flexDirection:'row',alignItems:'center',borderWidth:1,borderColor:'#E2E8F0'},
  avatar:{width:44,height:44,borderRadius:22,backgroundColor:'#1E6FD9',alignItems:'center',justifyContent:'center',flexShrink:0},
  formCard:{backgroundColor:'#fff',borderRadius:16,padding:20},
  label:{fontSize:12,fontWeight:'700',color:'#64748B',marginBottom:5,textTransform:'uppercase',letterSpacing:0.5},
  input:{height:50,borderRadius:12,borderWidth:1.5,borderColor:'#E2E8F0',backgroundColor:'#fff',paddingHorizontal:14,fontSize:14,color:'#0F172A',marginBottom:14},
  btnPrimary:{backgroundColor:'#1E6FD9',borderRadius:12,paddingVertical:14,alignItems:'center'},
  btnTxt:{color:'#fff',fontWeight:'800',fontSize:14},
});
