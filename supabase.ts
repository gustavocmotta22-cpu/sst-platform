import { createClient } from '@supabase/supabase-js';
import AsyncStorage from '@react-native-async-storage/async-storage';

const URL = 'https://wczkaffcaxxwvsjttqui.supabase.co';
const KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndjemthZmZjYXh4d3ZzanR0cXVpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE5MjMyOTMsImV4cCI6MjA5NzQ5OTI5M30.-nGRahiauKsU9FgmVyjMZpZnFyh-wEhnZNaThdAfrWE';

export const supabase = createClient(URL, KEY, {
  auth: {
    storage: AsyncStorage,
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: false,
  },
});

export async function signUp(email:string,senha:string,nome:string,telefone:string,cargo:string){
  const{data,error}=await supabase.auth.signUp({email,password:senha,options:{data:{nome,telefone,cargo}}});
  if(error)throw error;
  return data;
}

export async function signIn(email:string,senha:string){
  const{data,error}=await supabase.auth.signInWithPassword({email,password:senha});
  if(error)throw error;
  return data;
}

export async function getProfile(userId:string){
  const{data,error}=await supabase.from('profiles').select('*').eq('id',userId).maybeSingle();
  if(error){console.log('getProfile error:',JSON.stringify(error));return null;}
  return data;
}

export async function getAllUsers(){
  const{data}=await supabase.from('profiles').select('*').order('created_at',{ascending:false});
  return data||[];
}

export async function updateUserStatus(userId:string,status:string){
  await supabase.from('profiles').update({status}).eq('id',userId);
}

export async function salvar(tabela:string,dados:any,userId:string){
  const{data,error}=await supabase.from(tabela).insert({...dados,user_id:userId}).select().single();
  if(error)throw error;
  return data;
}

export async function listar(tabela:string,userId:string){
  const{data}=await supabase.from(tabela).select('*').eq('user_id',userId).order('created_at',{ascending:false});
  return data||[];
}

export async function checkTrial(userId:string):Promise<'ATIVO'|'TRIAL'|'EXPIRADO'|'BLOQUEADO'>{
  const{data}=await supabase.from('profiles').select('status,trial_fim,role').eq('id',userId).maybeSingle();
  if(!data)return 'TRIAL';
  if(data.role==='MASTER')return 'ATIVO';
  if(data.status==='BLOQUEADO')return 'BLOQUEADO';
  if(data.status==='ATIVO')return 'ATIVO';
  if(data.trial_fim&&new Date(data.trial_fim)<new Date()){
    await supabase.from('profiles').update({status:'EXPIRADO'}).eq('id',userId);
    return 'EXPIRADO';
  }
  return 'TRIAL';
}
