#ifndef _VALOR_
#define _VALOR_ Objecto
#endif

#ifndef _PRESCAN_
#define _PRESCAN_
#define AFTERDEF(x) define ## x
#define DEFCAPSULA(x) AFTERDEF(x)
#define AFTEROBT(x) obter ## x
#define OBTCAPSULA(x) AFTEROBT(x)
#define AFTERTEM(x) tem ## x
#define TEMCAPSULA(x) AFTERTEM(x)
#define AFTERMOS(x) mostrar ## x
#define MOSCAPSULA(x) AFTERMOS(x)
#define AFTERSELF(x) self% ## x
#define SELFCAPSULA(x) AFTERSELF(x)
#define AFTERC(x) C_ ## x
#define CVALOR(x) AFTERC(x)
#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)
#endif

	procedure						:: DEFCAPSULA(_VALOR_)
	procedure						:: OBTCAPSULA(_VALOR_)
	procedure						:: TEMCAPSULA(_VALOR_)
	procedure						:: MOSCAPSULA(_VALOR_)
