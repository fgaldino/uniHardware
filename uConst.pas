unit uConst;

interface

uses classes;

Type
TConstante = class

public

const
TituloSistema = 'Plugin Hardware Server';
FalhaStartServer = 'Não foi possível iniciar o '+TituloSistema;
SucessStartSever = TituloSistema+' iniciado';
StopServer = TituloSistema+' parado';
end;

Type Cons = class(TConstante);

implementation



end.
