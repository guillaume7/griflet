#ifndef _VALOR_
#define _VALOR_ Objecto
#endif

#ifndef _PRESCAN_
#define _PRESCAN_
#define AFTERALN(x) alocarNodoDe ## x
#define AFTERDEF(x) define ## x
#define AFTEROBT(x) obter ## x
#define AFTERTEM(x) tem ## x
#define AFTERMOS(x) mostrar ## x
#define AFTERADI(x) adicionar ## x
#define AFTERC(x)   C_ ## x
#define AFTERCOL(x)   C_Colecao_ ## x
#define AFTERALO(x) alocar ## x
#define AFTERDES(x) desalocar ## x
#define ALNODO(x)   AFTERALN(x)
#define DEFVALOR(x) AFTERDEF(x)
#define OBTVALOR(x) AFTEROBT(x)
#define TEMVALOR(x) AFTERTEM(x)
#define MOSVALOR(x) AFTERMOS(x)
#define ADIVALOR(x) AFTERADI(x)
#define CVALOR(x)   AFTERC(x)
#define COLVALOR(x) AFTERCOL(x)
#define ALOVALOR(x) AFTERALO(x)
#define DESVALOR(x) AFTERDES(x)
#endif

  type, public, extends(C_Colecao)  ::  COLVALOR(_VALOR_)

    class(CVALOR(_VALOR_)),  pointer     :: valor => null()

  contains

    procedure, nopass		    :: alocarNodo 	=> ALNODO(_VALOR_)
    procedure			    :: defineValor	=> DEFVALOR(_VALOR_)
    procedure			    :: obterValor	=> OBTVALOR(_VALOR_)
    procedure			    :: temValor		=> TEMVALOR(_VALOR_)
    procedure			    :: mostrarValor	=> MOSVALOR(_VALOR_)
    procedure			    :: adicionarValor	=> ADIVALOR(_VALOR_)
    procedure			    :: alocarValor	=> ALOVALOR(_VALOR_)
    procedure		    	    :: desalocarValor	=> DESVALOR(_VALOR_)

  end type COLVALOR(_VALOR_)

