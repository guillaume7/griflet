#ifndef _VALOR_
#define _VALOR_ Objecto
#endif

#ifndef _PRESCAN_
#define _PRESCAN_
#define AFTERDEF(x) define ## x
#define AFTEROBT(x) obter ## x
#define AFTERTEM(x) tem ## x
#define AFTERADI(x) adicionar ## x
#define AFTERC(x)   C_ ## x
#define AFTERALO(x) alocar ## x
#define AFTERDES(x) desalocar ## x
#define DEFVALOR(x) AFTERDEF(x)
#define OBTVALOR(x) AFTEROBT(x)
#define TEMVALOR(x) AFTERTEM(x)
#define ADIVALOR(x) AFTERADI(x)
#define CVALOR(x)   AFTERC(x)
#define ALOVALOR(x) AFTERALO(x)
#define DESVALOR(x) AFTERDES(x)
#endif

    !C_colecao de _VALOR_
    procedure			    :: DEFVALOR(_VALOR_)
    procedure			    :: OBTVALOR(_VALOR_)
    procedure			    :: TEMVALOR(_VALOR_)
    procedure			    :: ADIVALOR(_VALOR_)
    procedure, nopass               :: ALOVALOR(_VALOR_)
    procedure, nopass               :: DESVALOR(_VALOR_)
