SHELL = /bin/sh

SOURCES = \
      class_paises

TARGETS = $(subst class, class_colecao, $(SOURCES))

TEMPLATE = class_colecao

FILES = $(SOURCES) $(TEMPLATE) $(TARGETS)

.PRECIOUS : class_colecao_paises.f90

.PHONY : all clean

all : $(FILES)
	@echo Done .... $(basename $^)

clean : 
	rm -f $(FILES) \
		$(addsuffix .f90,$(FILES))\
		$(addsuffix .mod,$(FILES))\
		$(addsuffix .o,$(FILES))\
		$(addsuffix .x,$(FILES))

#$(FILES) : $(addsuffix .x, $(FILES))

#%.x : %.o
#	ifort $< -o $@
#	cp $@ $(basename $@)

class_colecao_paises.x : class_colecao_paises.o class_paises.o
	ifort $^ -o $@
	cp $@ $(basename $@)

%.o : %.f90
	ifort -c $<

%.f90 : %.F90
	ifort -D_TEMPLATING -E $< > $@

class_colecao_%.f90 : class_%.F90
	ifort \
		-D_CLASS_EXTENDIDA=$(basename $<) \
		-D_C_EXTENDIDA=$(subst class,C,$(basename $<)) \
		-D_CLASS_COLECAO=$(basename $@) \
		-D_C_COLECAO=$(subst class,C,$(basename $@)) \
		-E $(addsuffix .F90, $(TEMPLATE)) > $@

class_colecao_%.o : class_%.o

