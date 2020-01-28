CREATE OR REPLACE FUNCTION validaCPF( p_cpf VARCHAR2) RETURN BOOLEAN
AS
  e_error_cpf exception;
  PRAGMA EXCEPTION_INIT(e_error_cpf,-06502);
  v_cpf VARCHAR2(11);
  v_multiplicador number;
  v_soma number;
  v_resto1 number;
  v_resto2 number;
  v_digito_verif1 number;
  v_digito_verif2 number;
begin
   v_cpf := p_cpf;
  ------------ VALIDANDO OS CPF COM NUMEROS UNICOS -------------
  case v_cpf
    when '11111111111' then RETURN FALSE;
    when '22222222222' then RETURN FALSE;
    when '33333333333' then RETURN FALSE;
    when '44444444444' then RETURN FALSE;
    when '55555555555' then RETURN FALSE;
    when '66666666666' then RETURN FALSE;
    when '77777777777' then RETURN FALSE;
    when '88888888888' then RETURN FALSE;
    when '99999999999' then RETURN FALSE;
  end;
  ------------- CAPTURANDO OS DIGITOS VERIFICADORES --------------

  v_digito_verif1 := to_number(substr(v_cpf,10,1));
  v_digito_verif2 := to_number(substr(v_cpf,11,1));

  --------- ANALISE DO PRIMEIRO DIGITO VERIFICADOR ----------------

  v_multiplicador := 10;
  v_soma := 0;

  for i in 1..9
  loop
    v_soma := v_soma + (to_number(substr(v_cpf,i,1)) * v_multiplicador);
    v_multiplicador := v_multiplicador - 1;    
  end loop;
  v_resto1 := mod(v_soma * 10,11);
  
  if v_resto1 = 10
  then
     v_resto1 := 0;
  end if;
  
  --------- ANALISE DO SEGUNDO DIGITO VERIFICADOR ----------------  
  
  v_multiplicador := 11;
  v_soma := 0;
  for i in 1..10
  loop
    
    v_soma := v_soma + (to_number(substr(v_cpf,i,1)) * v_multiplicador);
    v_multiplicador := v_multiplicador - 1;    
  end loop;
   v_resto2 := mod(v_soma * 10,11);
   if v_resto2 = 10
   then
     v_resto2 := 0;
  end if;
  
  --------------- ANALISANDO SE O CPF EH VALIDO OU INVALIDO ---------------
  
  if (v_resto1 = v_digito_verif1) AND ( v_resto2 = v_digito_verif2)
  THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;  

EXCEPTION
   when e_error_cpf then
     RAISE_APPLICATION_ERROR(-20001,'O CPF DEVE CONTER APENAS NUMEROS');
end;