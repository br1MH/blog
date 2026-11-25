#import "@tola/source:0.0.0": tola-meta
#import "/utils/ui.typ": callout, hint, term
#import "/utils/diagram.typ": flows, n
#import "/utils/cetz.typ" as cetz
#import "/utils/figure.typ": arrow, c, txt

#tola-meta((
  title: "[Skolnik 01] Introducción al radar",
  date: "2026-11-23",
  summary: "Resumen del capítulo 1 de Introduction to Radar Systems (Skolnik, 3.ª ed.): principio del radar, ecuación del radar, diagrama de bloques, frecuencias, aplicaciones y orígenes.",
  tags: ("radar", "skolnik", "tfg"),
  series: "Skolnik",
  part: 1,
))

#show math.equation: set text(
  font: "STIX Two Math",
)

#set math.equation(numbering: "(1)")

// Convenio de referencias: [L-D] = libro de Skolnik, 3.ª ed., página impresa D
// (la página del PDF es la impresa + 12).

= Introducción al radar

== Radar básico

=== Idea general

Un *radar* es un sistema electromagnético que detecta y localiza objetos reflectantes (aviones, barcos, vehículos, personas o el propio entorno natural). Radia energía al espacio y detecta el eco que devuelve el objeto, llamado *blanco*. Comparar el eco recibido con la señal transmitida permite no solo constatar la presencia del blanco, sino también conocer su posición y otras características. Como el radar lleva su propia iluminación, funciona de noche y con niebla, lluvia o nieve, y su capacidad de medir distancias con precisión en cualquier condición meteorológica es su atributo más valioso.
// Esta idea se encuentra en [L-1]

El principio de funcionamiento tiene cuatro pasos: el transmisor genera una señal (típicamente un pulso corto de una sinusoide), la antena la radia, el blanco reirradia parte de la energía interceptada en muchas direcciones, y la antena recoge la fracción que vuelve hacia el radar y se la entrega al receptor, donde se detecta el blanco y se extrae su información. Cuando la forma de onda es una serie de pulsos, una única antena se comparte en el tiempo entre transmisión y recepción.
// Esta explicación y la Fig. 1.1 se encuentran en [L-1] y [L-2]

La información que se extrae del eco es la siguiente:

- La *distancia* (en terminología radar, *alcance* o _range_) se mide con el retardo del eco. Es la magnitud que da nombre a esta sección y la que se desarrolla a continuación.
- La *dirección* del blanco es la hacia la que apunta la antena, de haz estrecho, cuando la amplitud del eco es máxima.
- La *velocidad radial* se obtiene del desplazamiento de frecuencia del eco por efecto Doppler, que es proporcional a la velocidad del blanco relativa al radar.
// Estas tres magnitudes se encuentran en [L-2]

El desplazamiento Doppler es la base para separar blancos en movimiento de los ecos fijos no deseados del entorno (tierra, mar o lluvia), conocidos como #term("clutter")[Ecos no deseados procedentes del entorno natural: terreno, mar, lluvia, etc. Compiten con el eco del blanco y obligan a procesar la señal para rechazarlos.]. Estos temas se retoman en el capítulo 3.

#hint[La palabra _range_ en radar significa distancia, no "alcance de un proyectil" como en algunos diccionarios [L-2].]

El término *radar* es una contracción de _radio detection and ranging_. Refleja que los primeros desarrolladores se centraron en detectar la presencia de un blanco y medir su distancia, función para la que ninguna otra técnica compite en alcances largos con tiempo despejado o adverso [L-2].

=== Distancia a un blanco

La forma de onda más habitual es una serie de pulsos de corta duración, aproximadamente rectangulares, que modulan una portadora sinusoidal (el llamado *tren de pulsos*). Sea $T_R$ el tiempo que tarda el pulso en ir al blanco y volver. La distancia al blanco es

$ R = (c T_R)/2, $ <eq-distancia>
// Esta expresión se encuentra en [L-2]

donde $c approx 3 dot 10^8 "m/s"$ es la velocidad de la luz en el vacío. El factor $1/2$ aparece porque el pulso recorre la distancia dos veces: la propagación hasta el blanco y de vuelta ocupa un tiempo $2 R / c$, y despejar $R$ en esta igualdad da la @eq-distancia.

Con la distancia en kilómetros o millas náuticas y $T_R$ en microsegundos, la @eq-distancia adopta las formas numéricas

$ R("km") = 0.15 T_R (mu "s") quad "o" quad R("nmi") = 0.081 T_R (mu "s"). $ <eq-distancia-num>
// Esta expresión se encuentra en [L-3]

Cada microsegundo de tiempo de ida y vuelta equivale a 150 m (164 yardas, 492 pies, 0.081 millas náuticas o 0.093 millas terrestres), y una milla náutica requiere 12.35 $mu "s"$ de ida y vuelta [L-3]. La primera cifra es consecuencia directa de la @eq-distancia: $c/2 = 1.5 dot 10^8 "m/s" = 150 "m"/(mu "s")$.

=== Alcance máximo no ambiguo

Si se transmiten pulsos con periodo de repetición $T_p$, el eco de un blanco lejano puede llegar después de transmitido el pulso siguiente. El radar lo asociaría entonces al pulso equivocado y mediría una distancia errónea. Los ecos que llegan tras la transmisión del siguiente pulso se llaman *ecos de segunda vuelta* (o de varias vueltas, si proceden de pulsos aún anteriores). El *alcance máximo no ambiguo* $R_"un"$ es la distancia a partir de la cual los blancos aparecen como ecos de segunda vuelta:

$ R_"un" = (c T_p)/2 = c/(2 f_p), $ <eq-rango-no-ambiguo>
// Esta expresión se encuentra en [L-3]

con $T_p = 1 / f_p$ el *periodo de repetición de pulsos* y $f_p$ la *frecuencia de repetición de pulsos* (PRF, en Hz o pulsos por segundo). La @eq-rango-no-ambiguo es la @eq-distancia evaluada en $T_R = T_p$: es la distancia cuyo eco regresa justo cuando sale el pulso siguiente. La Fig. 1.2 del libro representa $R_"un"$ en función de $f_p$ [L-4].

La PRF debe, por tanto, elegirse según la distancia máxima a la que se esperan blancos: una PRF alta acorta $R_"un"$ y una PRF baja lo alarga.

#callout(kind: "note", title: [APARIENCIA DE UN ECO DE SEGUNDA VUELTA])[
  El libro indica que un eco de segunda vuelta aparece _más cerca_ de lo que está el blanco [L-3]. Precisando: el radar asocia cada eco al último pulso transmitido, de modo que mide el retardo $2 R / c$ módulo $T_p$. Un blanco a distancia $R > R_"un"$ se mide entonces a la distancia aparente $R - k R_"un"$, con $k$ el mayor entero tal que $k R_"un" <= R$ y, por tanto, $0 <= R - k R_"un" < R_"un"$. Esta precisión es deducción propia a partir de la @eq-rango-no-ambiguo y no aparece en el libro.
]

=== Formas de onda del radar

Un radar típico emplea la forma de onda pulsada de la @fig-tren-pulsos. Sus parámetros son la *potencia de pico* $P_t$, la *anchura de pulso* $tau$ y el periodo $T_p$. A partir de ellos se definen las siguientes magnitudes.

#figure(
  cetz.canvas(length: 1pt, {
    import cetz.draw: *
    let h = 56
    arrow((0, 0), (500, 0), color: c.ink, w: .8pt)
    content((504, 0), txt(fill: c.ink)[$t$], anchor: "west")
    for x0 in (20, 220, 420) {
      rect((x0, 0), (x0 + 22, h), fill: c.orange1, stroke: .8pt + c.orange)
    }
    // Eco del primer pulso: retardado y mucho más débil (fuera de escala).
    rect((120, 0), (142, 6), fill: c.blue1, stroke: .6pt + c.blue)
    content((131, 10), txt(fill: c.blue)[eco], anchor: "south")
    // Potencia de pico.
    line((-4, h), (20, h), stroke: (paint: c.grey2, thickness: .5pt, dash: "dashed"))
    content((-8, h), txt(fill: c.ink)[$P_t$], anchor: "east")
    // Anchura de pulso.
    line((20, h + 6), (20, h + 14), stroke: .5pt + c.line)
    line((42, h + 6), (42, h + 14), stroke: .5pt + c.line)
    line((20, h + 10), (42, h + 10), stroke: .5pt + c.line)
    content((31, h + 16), txt(fill: c.ink)[$tau$], anchor: "south")
    // Retardo del eco y periodo de repetición.
    line((20, -8), (20, -16), stroke: .5pt + c.line)
    line((120, -8), (120, -16), stroke: .5pt + c.line)
    line((20, -12), (120, -12), stroke: .5pt + c.line)
    content((70, -14), txt(fill: c.ink)[$T_R$], anchor: "north")
    line((220, -8), (220, -34), stroke: .5pt + c.line)
    line((20, -30), (220, -30), stroke: .5pt + c.line)
    content((120, -32), txt(fill: c.ink)[$T_p$], anchor: "north")
  }),
  caption: [Tren de pulsos con un eco (esquema fuera de escala). Basada en la Fig. 1.3 de [L-4].],
) <fig-tren-pulsos>
// Esta figura se encuentra en [L-4]

La *potencia media* y el *ciclo de trabajo* de un tren de pulsos rectangulares son

$ P_"av" = P_t tau / T_p = P_t tau f_p, quad d = tau / T_p = tau f_p = P_"av" / P_t. $ <eq-potencia-media>
// Estas expresiones se encuentran en [L-3]

El ciclo de trabajo $d$ es la fracción del tiempo en que el radar radia, y la energía de un pulso es $P_t tau$. Con los valores ilustrativos del libro (similares a un radar de vigilancia aérea de alcance medio, no a un radar concreto), $P_t = 1 "MW"$, $tau = 1 mu "s"$ y $T_p = 1 "ms"$, se obtiene:

$ f_p &= 1000 "Hz", \
  R_"un" &= 150 "km" approx 81 "nmi", \
  P_"av" &= 10^6 dot 10^(-6) dot 10^3 "W" = 1 "kW", \
  d &= 0.001, \
  P_t tau &= 1 "J". $
// Estos valores se encuentran en [L-3]

Si el radar pudiera detectar una señal de $10^(-12) "W"$, el eco estaría por debajo de la señal transmitida en

$ 10 log_10 (10^(-12) / 10^6) = -180 "dB". $
// Este valor se encuentra en [L-3]

Esta enorme diferencia de nivel explica por qué conviene una forma de onda pulsada de corta duración: el potente transmisor no radia mientras se recibe el débil eco.

Además del retardo, la anchura de pulso fija la *resolución en distancia*. Un pulso de anchura $tau$ ocupa en el espacio una longitud $c tau$ (300 m para $tau = 1 mu "s"$). Dos blancos iguales son resolubles en distancia cuando su separación es la mitad de esa longitud, por el mismo recorrido de ida y vuelta que dio el factor $1/2$ en la @eq-distancia:

$ Delta R = (c tau)/2. $ <eq-resolucion>
// Esta expresión no aparece numerada; se encuentra en [L-4] y [L-5] (150 m para 1 µs)

Surge así un compromiso. Algunos radares de largo alcance necesitan pulsos muy largos para alcanzar energía suficiente, pero un pulso largo resuelve mal en distancia. La *compresión de pulsos* lo evita: una modulación de frecuencia o fase ensancha el espectro del pulso largo hasta conseguir la resolución de uno corto (Sec. 6.5 del libro) [L-5].

Existen otras formas de onda:

- Las de *onda continua* (CW) reciben mientras transmiten, por lo que dependen del Doppler para separar en frecuencia el débil eco de la fuerte señal transmitida y del clutter. Un radar CW simple no mide distancia, pero la obtiene si se modula la portadora en frecuencia o fase; un ejemplo es el altímetro radar FM-CW.
- Los radares pulsados que explotan el Doppler se dividen en *MTI* (indicación de blancos móviles), con PRF y ciclo de trabajo bajos, y *Doppler pulsado*, con PRF y ciclo de trabajo altos. Casi todos los radares que detectan aeronaves usan el Doppler para rechazar el clutter estacionario.
// Estas formas de onda se encuentran en [L-5]

== La forma simple de la ecuación del radar

=== Resultado

La *ecuación del radar* relaciona el alcance con las características del transmisor, el receptor, la antena, el blanco y el entorno. Sirve para calcular la distancia máxima a la que un radar detecta un blanco, para entender qué factores gobiernan su rendimiento y como herramienta de diseño. Su forma más simple, que supone un receptor limitado solo por ruido, es

$ R_"max" = ( (P_t G A_e sigma) / ((4 pi)^2 S_"min") )^(1/4). $ <eq-radar-fundamental>
// Esta expresión se encuentra en [L-6]

Aquí $P_t$ es la potencia transmitida (en este texto, la potencia de pico), $G$ la ganancia de transmisión de la antena, $A_e$ su área efectiva de recepción, $sigma$ la sección radar del blanco y $S_"min"$ la mínima señal detectable. Salvo $sigma$, todos los parámetros están bajo control del diseñador. La ecuación indica qué hacer para alcanzar más distancia: aumentar la potencia transmitida, concentrar la energía en un haz estrecho (ganancia grande), recibir con una apertura grande y emplear un receptor sensible a señales débiles.
// Esta lectura se comenta en [L-30] (inicio del capítulo 2) y en [L-6]

=== Deducción

La deducción sigue la energía en su camino hasta el blanco y de regreso, y se apoya en la idea ya vista de que todo ocurre en el tiempo de ida y vuelta de la @eq-distancia. Primero se considera una antena *isótropa*, que radia uniformemente en todas las direcciones. La potencia $P_t$ se reparte sobre una esfera imaginaria de radio $R$ y superficie $4 pi R^2$, de modo que la densidad de potencia (en $"W/m"^2$) es $P_t / (4 pi R^2)$ [L-5]. Un radar usa una antena directiva, cuya *ganancia* $G$ es el cociente entre la densidad de potencia máxima que radia y la que radiaría una antena isótropa sin pérdidas con la misma potencia de entrada [L-6]. La densidad de potencia en el blanco es entonces

$ (P_t G) / (4 pi R^2). $ <eq-densidad-blanco>
// Esta expresión se encuentra en [L-6] (Ec. 1.4)

El blanco intercepta parte de esa energía y la reirradia en muchas direcciones, pero solo interesa la densidad reirradiada hacia el radar. La *sección radar* $sigma$ (también sección recta radar o simplemente sección) se define precisamente como el área que convierte la densidad incidente en densidad devuelta al radar:

$ "densidad devuelta" = (P_t G) / (4 pi R^2) dot sigma / (4 pi R^2). $ <eq-densidad-devuelta>
// Esta expresión se encuentra en [L-6] (Ec. 1.5)

El segundo factor tiene la forma de la densidad producida a distancia $R$ por una fuente de potencia $sigma$ (por eso aparece otro $4 pi R^2$ en el denominador): la propagación de regreso es otra expansión esférica. Aunque $sigma$ tiene unidades de área, asociarla directamente con el tamaño físico del blanco puede inducir a error: depende más de su forma que de su tamaño (Sec. 2.7).

La antena receptora captura una fracción de ese eco que viene dada por su *área efectiva* $A_e = rho_a A$, con $A$ el área física y $rho_a$ la eficiencia de apertura. La potencia recibida $P_r$ es el producto de la densidad devuelta por $A_e$:

$ P_r &= (P_t G) / (4 pi R^2) dot sigma / (4 pi R^2) dot A_e \
  &= (P_t G A_e sigma) / ((4 pi)^2 R^4). $ <eq-pr>
// Esta expresión se encuentra en [L-6] (Ec. 1.6)

La @eq-pr muestra que la potencia recibida decae como $R^(-4)$. El *alcance máximo* $R_"max"$ es la distancia más allá de la cual el blanco no se detecta. Como $P_r$ es una función estrictamente decreciente de $R$, el blanco es detectable (en el modelo simple) si y solo si $P_r >= S_"min"$, es decir, si y solo si $R <= R_"max"$, donde $R_"max"$ es la distancia con $P_r = S_"min"$. Sustituir $P_r = S_"min"$ en la @eq-pr y despejar $R$ da la @eq-radar-fundamental:

$ S_"min" = (P_t G A_e sigma) / ((4 pi)^2 R_"max"^4) quad <=> quad R_"max" = ( (P_t G A_e sigma) / ((4 pi)^2 S_"min") )^(1/4). $
// Este paso se encuentra en [L-6] (Ec. 1.7)

=== Formas equivalentes y su interpretación

Si la misma antena transmite y recibe, como es habitual en radar, la teoría de antenas liga la ganancia con el área efectiva mediante

$ G = (4 pi A_e) / lambda^2 = (4 pi rho_a A) / lambda^2, $ <eq-ganancia-area>
// Esta expresión se encuentra en [L-6] (Ec. 1.8)

donde $lambda = c / f$ es la longitud de onda y $f$ la frecuencia. Sustituir la @eq-ganancia-area en la @eq-radar-fundamental, primero para $A_e$ y luego para $G$, da otras dos formas de la ecuación del radar:

$ R_"max" &= ( (P_t G^2 lambda^2 sigma) / ((4 pi)^3 S_"min") )^(1/4), \
  R_"max" &= ( (P_t A_e^2 sigma) / (4 pi lambda^2 S_"min") )^(1/4). $ <eq-radar-formas>
// Estas expresiones se encuentran en [L-7] (Ecs. 1.9 y 1.10)

La comprobación es inmediata: con $A_e = G lambda^2 / (4 pi)$ el producto $G A_e$ se convierte en $G^2 lambda^2 / (4 pi)$, y con $G = 4 pi A_e / lambda^2$ se convierte en $4 pi A_e^2 / lambda^2$. Las tres formas (@eq-radar-fundamental y las dos de la @eq-radar-formas) son esencialmente la misma, pero se interpretan de modo distinto.

#callout(kind: "warning", title: [¿CÓMO VARÍA EL ALCANCE CON LA LONGITUD DE ONDA?])[
  La primera forma de la @eq-radar-formas sugiere $R_"max" prop lambda^(1 / 2)$ y la segunda $R_"max" prop lambda^(-1 / 2)$, justo lo contrario, mientras que la @eq-radar-fundamental no muestra dependencia explícita de $lambda$. La interpretación correcta depende de qué se mantiene constante al variar la longitud de onda (o la frecuencia): la ganancia $G$ en la primera forma, el área efectiva $A_e$ en la segunda. Para que la @eq-radar-fundamental fuera independiente de la frecuencia harían falta dos antenas, una transmisora con ganancia independiente de $lambda$ y una receptora con apertura efectiva independiente de $lambda$, lo cual rara vez se hace [L-7].
]

=== Limitaciones

La forma simple no describe adecuadamente un radar real, porque omite factores importantes (pérdidas, fluctuación del eco, ruido externo, propagación, entre otros), y puede predecir alcances demasiado altos, a veces en un factor dos o más. El capítulo 2 la amplía con esos factores para acercarla al comportamiento observado [L-7].

== Diagrama de bloques del radar

=== Resultado: la cadena transmisor-antena-receptor

La operación de un radar de pulsos se describe con el diagrama de la @fig-bloques. Del lado de transmisión, un *generador de forma de onda* produce la señal a baja potencia, un *amplificador de potencia* la eleva y el *duplexor* la entrega a la antena. Del lado de recepción, la señal captada se amplifica, se convierte a frecuencia intermedia, se filtra para maximizar la relación señal/ruido, se detecta y se compara con un umbral para decidir si hay blanco.
// Este diagrama se encuentra en [L-8] (Fig. 1.4)

#figure(
  flows(
    ([TRANSMISIÓN], (
      n([Generador de forma de onda]),
      [baja potencia],
      n([Amplificador de potencia], sub: [con modulador de pulsos], tone: "accent"),
      [pulso RF de alta potencia],
      n([Duplexor]),
      [guía de ondas],
      n([Antena], tone: "dark"),
    )),
    ([RECEPCIÓN], (
      n([Antena], tone: "dark"),
      [eco],
      n([Duplexor]),
      [pulso RF],
      n([Amplificador RF de bajo ruido]),
      [señal RF],
      n([Mezclador], sub: [con oscilador local]),
      [pulso FI],
      n([Amplificador FI y filtro adaptado], tone: "accent"),
      [pulso FI filtrado],
      n([Segundo detector (demodulador)]),
      [pulso de vídeo],
      n([Amplificador de vídeo]),
      [señal de vídeo],
      n([Decisión por umbral], tone: "dark"),
    )),
  ),
  caption: [Diagrama de bloques de un radar de pulsos con receptor superheterodino, reordenado en dos cadenas a partir de la Fig. 1.4 de [L-8].],
) <fig-bloques>
// Esta figura se encuentra en [L-8]

=== Transmisor y antena

El transmisor puede ser un *amplificador de potencia* (klistrón, tubo de onda progresiva o amplificador de transistores) o un *oscilador de potencia*, como el #term("magnetrón")[Oscilador de potencia de microondas. Su invención en versión de alta potencia (magnetrón de cavidades) abrió el radar a frecuencias de microondas, ver la sección de orígenes.]. El magnetrón se ha usado ampliamente en radares de capacidad modesta. Se prefiere el amplificador cuando se necesita alta potencia media, formas de onda más complejas que un pulso simple (como la compresión de pulsos) o buen rendimiento al detectar blancos móviles en medio de clutter mucho mayor mediante el Doppler (capítulo 3). Salvo en las fuentes de estado sólido, un *modulador* enciende y apaga el transmisor en sincronía con los pulsos de entrada, y con un oscilador de potencia el modulador genera directamente el tren de pulsos [L-7].

La salida del transmisor llega a la antena por una guía de ondas u otra línea de transmisión. La antena puede ser un reflector parabólico o una agrupación plana de orientación mecánica, o una agrupación en fase de orientación electrónica (capítulo 9). El reflector parabólico concentra la energía en un haz estrecho, como el faro de un coche. Una agrupación en fase es un conjunto de numerosos elementos radiantes pequeños cuyas señales se combinan en el espacio para producir una onda plana, y desfasadores en cada elemento permiten cambiar rápidamente la dirección del haz sin mover la antena [L-7] y [L-8].

Como estimación cuando no se dispone de más datos, el ancho de haz de un reflector parabólico "típico" es

$ theta_B approx 65 lambda / D quad "(grados)", $ <eq-ancho-haz>
// Esta expresión no está numerada; se encuentra en [L-8]

donde $D$ es la dimensión de la antena en el plano en que se mide el ancho de haz. Por ejemplo, una antena con $D = 32.5 lambda$ tiene un ancho de haz acimutal $theta_B approx 65 / 32.5 = 2°$; a 3 GHz ($lambda = 10 "cm"$) mide $32.5 dot 0.1 "m" = 3.25 "m"$ (10.7 pies). El giro de 360° en acimut de una antena de vigilancia es el *barrido de antena*, con velocidades típicas de 6 rpm en un radar civil de control de tráfico aéreo de largo alcance y mayores en los militares [L-8].

=== Duplexor

El *duplexor* permite compartir la antena en el tiempo entre transmisión y recepción. Suele ser un dispositivo gaseoso que provoca un cortocircuito (una descarga en arco) a la entrada del receptor mientras el transmisor funciona, de modo que la alta potencia fluye a la antena y no al receptor. En recepción dirige el eco al receptor y no al transmisor. También pueden formar parte del duplexor circuladores de ferrita y dispositivos protectores del receptor, normalmente diodos de estado sólido [L-8].

=== Receptor

El receptor es casi siempre un #term("superheterodino")[Receptor que convierte la señal de radiofrecuencia a una frecuencia intermedia fija, donde se amplifica y filtra.]. La etapa de entrada (RF) puede ser un amplificador transistorizado de bajo ruido. El mezclador y el oscilador local (LO) convierten la señal RF a una *frecuencia intermedia* (FI), donde la amplifica el amplificador de FI. Su ancho de banda fija el de la señal. Para un pulso de 1 $mu "s"$ la FI puede ser de 30 o 60 MHz, con un ancho de banda cercano a 1 MHz [L-8] y [L-9].

El amplificador de FI se diseña como *filtro adaptado* (Sec. 5.2), el que maximiza la relación entre la potencia pico de señal y la potencia media de ruido a su salida, y así maximiza la detectabilidad de los ecos débiles y atenúa las señales no deseadas. Para los pulsos aproximadamente rectangulares habituales, un filtro convencional se acerca al adaptado cuando el ancho de banda $B$ es la inversa de la anchura de pulso:

$ B tau approx 1. $ <eq-filtro-adaptado>
// Esta expresión no está numerada; se encuentra en [L-9]

Con $tau = 1 mu "s"$ esto da $B approx 1 "MHz"$, de acuerdo con el valor de FI citado antes.

#callout(kind: "info", title: [ENTRADA SIN AMPLIFICADOR DE BAJO RUIDO])[
  A veces se omite la etapa de bajo ruido y el mezclador es la primera etapa. El receptor es entonces menos sensible por la mayor cifra de ruido del mezclador, pero gana margen dinámico y se vuelve menos susceptible a la sobrecarga y a las interferencias electrónicas (Sec. 11.3). Esto puede interesar en radares militares sometidos al entorno ruidoso de las #term("ECM")[Contramedidas electrónicas (_electronic countermeasures_): interferencia deliberada contra un radar.] hostiles [L-9].
]

=== Detección y decisión

Al diodo de cristal que sigue al amplificador de FI se le llama tradicionalmente *segundo detector* o demodulador. Junto con el amplificador de FI y el de vídeo actúa como *detector de envolvente*: deja pasar la envolvente del pulso y rechaza la portadora. Ambos amplificadores aportan la ganancia necesaria para llevar la señal a un nivel que pueda verse en una pantalla o procesarse en un ordenador. En los radares que detectan el desplazamiento Doppler, el detector de envolvente se sustituye por un detector de fase (Sec. 3.1) [L-9].

A la salida del receptor se *decide* si hay o no blanco según la magnitud de la señal: si supera un umbral predeterminado se declara un blanco y, en caso contrario, se supone que solo hay ruido. El umbral se fija para que la tasa de falsas alarmas por cruces del umbral debidos al ruido, en ausencia de señal, quede por debajo de un valor tolerable. Esto es suficiente mientras el ruido es constante (dominado por el del receptor). Si el ruido es externo (interferencias o inhibición deliberada) o si el clutter supera al ruido del receptor, el umbral debe variar adaptativamente para mantener constante la tasa de falsas alarmas, lo que hace un receptor #term("CFAR")[Constant False Alarm Rate: receptor cuyo umbral se adapta para mantener constante la tasa de falsas alarmas (Sec. 5.7).] [L-9].

=== Procesado de señal, de datos y presentación

Un radar suele recibir muchos pulsos de un mismo blanco. La suma de esos pulsos antes de decidir, para obtener mayor relación señal/ruido, es la *integración*, que suele realizarse en la parte de vídeo del receptor. El *procesador de señal* es la parte del radar que deja pasar el eco deseado y rechaza señales no deseadas, ruido y clutter, y se halla antes de la decisión de detección. El filtro adaptado es un ejemplo, y el filtro Doppler que separa los blancos móviles del clutter estacionario es otro [L-9] y [L-10].

Algunos radares procesan además la detección en el *procesador de datos* antes de presentarla. Un ejemplo es el seguidor automático, que usa las posiciones medidas durante un intervalo para establecer la pista (trayectoria) del blanco. La mayoría de los radares modernos de vigilancia aérea entregan pistas en lugar de simples detecciones. Los procesadores de señal y de datos son hoy mayoritariamente digitales, de ahí la importancia del conversor analógico-digital y de la memoria digital [L-10].

La presentación típica de un radar de vigilancia es el *PPI* (indicador de posición en el plano), que representa en coordenadas polares el acimut y la distancia de los blancos y gira en sincronía con la antena (Fig. 1.5). El *B-scope* es similar pero en formato rectangular (distancia frente a ángulo), y el *A-scope* es una presentación rectangular de amplitud frente a distancia (o retardo), más propia del seguimiento. Los primeros radares mostraban al operador vídeo en bruto, mientras que los modernos suelen presentar vídeo procesado (tras procesado de señal y detección por umbral o tras seguimiento automático), lo cual alivia al operador pero puede eliminar información del entorno que un operador entrenado sabría interpretar [L-10] y [L-11].

#callout(kind: "note", title: [MODOS DE OPERACIÓN])[
  Un radar puede operar en varios modos, con distintas frecuencias, polarizaciones, anchuras de pulso, PRF y procesados contra distintos tipos de clutter, interferencia e inhibición. La polarización de la onda se define por la dirección de su vector de campo eléctrico. Un operador entrenado puede seleccionar el modo, pero puede saturarse, y el radar puede diseñarse para elegir y ejecutar el modo automáticamente, a menudo en función de la dirección de la antena o de la distancia [L-11].
]

== Frecuencias del radar

Los radares convencionales operan en la región de microondas (término no definido con rigidez). Los operativos han abarcado desde unos 100 MHz hasta 36 GHz, más de ocho octavas. No son límites estrictos: los radares transhorizonte de HF operan desde pocos megahercios y existen radares experimentales de ondas milimétricas por encima de 240 GHz [L-11].

Durante la Segunda Guerra Mundial se usaron códigos de letras (S, X, L, ...) para designar las bandas en las que se desarrollaba el radar de microondas, por secreto militar, y se mantuvieron después como notación abreviada. La @tab-bandas recoge las designaciones aprobadas como estándar IEEE, relacionadas con las asignaciones de la UIT para radiolocalización. Por ejemplo, la banda L va oficialmente de 1000 a 2000 MHz, pero un radar de banda L solo puede operar entre 1215 y 1400 MHz, la banda asignada por la UIT [L-12].

#figure(
  table(
    columns: 3,
    table.header[Banda][Rango nominal][Asignaciones UIT para radar (región 2)],
    [HF], [3–30 MHz], [—],
    [VHF], [30–300 MHz], [138–144 MHz \ 216–225 MHz],
    [UHF], [300–1000 MHz], [420–450 MHz \ 850–942 MHz],
    [L], [1–2 GHz], [1215–1400 MHz],
    [S], [2–4 GHz], [2300–2500 MHz \ 2700–3700 MHz],
    [C], [4–8 GHz], [5250–5925 MHz],
    [X], [8–12 GHz], [8500–10 680 MHz],
    [K#sub[u]], [12–18 GHz], [13.4–14.0 GHz \ 15.7–17.7 GHz],
    [K], [18–27 GHz], [24.05–24.25 GHz],
    [K#sub[a]], [27–40 GHz], [33.4–36 GHz],
    [V], [40–75 GHz], [59–64 GHz],
    [W], [75–110 GHz], [76–81 GHz \ 92–100 GHz],
    [mm], [110–300 GHz], [126–142 GHz \ 144–149 GHz \ 231–235 GHz \ 238–248 GHz],
  ),
  caption: [Designaciones de bandas de frecuencia de radar según el estándar IEEE 521-1984. Tabla 1.1 de [L-12].],
) <tab-bandas>
// Esta tabla se encuentra en [L-12]

#callout(kind: "warning", title: [NO CONFUNDIR CON LAS BANDAS DE GUERRA ELECTRÓNICA])[
  La Tabla 1.1 es el único conjunto de designaciones que el IEEE aprueba para radar. Existe otro conjunto de letras, definido por el Departamento de Defensa de EE. UU. para ejercicios de contramedidas electrónicas, que a veces se extiende por error a las frecuencias de radar. Puede haber inhibidores en banda J, pero según el estándar IEEE no hay radares en banda J [L-12].
]

La notación de letras no sustituye a las frecuencias numéricas reales de un radar: estas se indican siempre que proceda y las letras se reservan para abreviar [L-13].

== Aplicaciones del radar

El radar detecta blancos en tierra, mar, aire, espacio e incluso bajo el suelo. Las principales áreas de aplicación son las siguientes [L-13] y [L-14]:

- *Militar.* Es parte esencial de la defensa aérea (vigilancia y control de armas) y de la operación de misiles y otras armas (guiado y espoleta). Los radares de alta resolución, como el de apertura sintética (SAR), se usan para reconocimiento y para detectar blancos fijos y móviles en el campo de batalla. El ámbito militar ha sido el mayor usuario de radar y el principal impulsor de su tecnología.
- *Teledetección.* Observación meteorológica, observación planetaria (por ejemplo, cartografiar Venus bajo sus nubes opacas), sondeo subterráneo de corto alcance y cartografía del hielo marino.
- *Control de tráfico aéreo.* Control del tráfico en el entorno de los aeropuertos (ASR), en ruta (ARSR) y en superficie (ASDE), y radares meteorológicos dedicados como el TDWR. El sistema de radiobaliza ATCRBS y el Modo S, aunque no son un radar, derivan del IFF militar y usan tecnología similar.
- *Cumplimiento de la ley y seguridad vial.* Radar de velocidad policial, aviso de colisión, activación de airbag y detección de obstáculos o intrusos.
- *Seguridad y navegación aérea.* Radar meteorológico de a bordo, radares de evitación y seguimiento del terreno, cartografía del suelo y radioaltímetro.
- *Seguridad marítima.* Evitación de colisiones, observación de boyas y vigilancia de puertos y ríos.
- *Espacio.* Encuentro y acoplamiento, alunizaje, exploración planetaria, detección y seguimiento de satélites y radioastronomía.
- *Otras.* Medida sin contacto de velocidad y distancia en la industria, prospección de petróleo y gas, y estudio de los movimientos de insectos y aves.

Los tamaños y alcances de los radares son muy diversos. Los hay que caben en la mano y otros que ocupan varios campos de fútbol, y que operan desde casi tocar el blanco hasta alcanzar los planetas. El libro ilustra esta diversidad con las Figs. 1.6 a 1.15, entre ellas el radar de vigilancia aeroportuaria ASR-9 (banda S, klistrón de 1.3 MW de pico, anchura de pulso de 1.0 $mu "s"$) [L-20] y el de detección de superficie ASDE-3 (banda K#sub[u], 3 kW de pico, ancho de haz acimutal de 0.25°) [L-21].

== Orígenes del radar

=== Los antecedentes

El concepto básico del radar lo demostraron los experimentos de Heinrich Hertz entre 1885 y 1888, que verificaron las predicciones de la teoría electromagnética de Maxwell (1864). Hertz mostró que las ondas de radio, de frecuencia muy distinta de la luz pero de comportamiento análogo, se reflejaban en objetos metálicos y se refractaban en un prisma dieléctrico, con un aparato similar en principio a un radar de pulsos hacia 455 MHz. No exploró aplicaciones prácticas [L-14].

Lo hizo Christian Hülsmeyer, que a comienzos del siglo XX montó lo que hoy se llamaría un radar de pulsos #term("monoestático")[Radar con transmisor y receptor en un único emplazamiento.] y lo patentó en 1904 para evitar colisiones de barcos. Pese a las demostraciones, no suscitó interés y quedó olvidado, por lo que el radar tendría que redescubrirse varias veces [L-15].

En la década de 1920 aparecieron más indicios. Marconi señaló en 1922 la detección de blancos por radio y defendió su uso. Ese mismo otoño, Taylor y Young, del Laboratorio de Investigación Naval de EE. UU., observaron por azar una señal fluctuante al cruzar un barco entre un transmisor y un receptor en orillas opuestas de un río, lo que hoy se llama radar CW #term("biestático")[Radar con transmisor y receptor en dos emplazamientos muy separados.]. En 1925, Breit y Tuve emplearon la técnica de pulsos para medir la altura de la ionosfera, sin advertir su aplicabilidad a barcos y aviones. Los radares biestáticos de onda continua, de configuración incómoda, solo servían de "cable trampa" para detectar el paso de un blanco, y el radar solo resultó verdaderamente útil con transmisor y receptor en un mismo emplazamiento y formas de onda pulsadas [L-15].

El impulso militar vino de los grandes bombarderos de finales de los años veinte y treinta, que hicieron necesario el aviso a larga distancia. Los localizadores de sonido, la detección del ruido de encendido del motor y el infrarrojo se mostraron insuficientes (alcance escaso, ausencia de funcionamiento en cualquier clima o falta de medida de la distancia) [L-15].

=== El redescubrimiento en los años treinta

En los años treinta el radar se redescubrió casi simultánea e independientemente en EE. UU., Reino Unido, Alemania, Unión Soviética, Francia, Italia, Japón y Países Bajos. Los primeros radares operaban a frecuencias mucho menores que las actuales, en general entre 100 y 200 MHz: el Chain Home británico a 30 MHz y el Würzburg alemán a 600 MHz representaban los extremos bajo y alto [L-16]. El resumen por países es el siguiente [L-16] a [L-18]:

- *Estados Unidos.* La Armada intentó un desarrollo biestático en 1922 y 1931, pero el esfuerzo serio empezó en 1934, al comprender Taylor y Young que hacía falta un radar de pulsos monoestático. En Pearl Harbor (7 de diciembre de 1941) la Armada había recibido 132 equipos y el Ejército disponía de radares SCR-268 y SCR-270, uno de los cuales detectó el ataque.
- *Reino Unido.* Empezó más tarde pero con más urgencia, y puso en servicio el Chain Home de 30 MHz a finales del verano de 1938. Se le atribuye un papel clave en la Batalla de Inglaterra (1940). En 1940 inventó además el magnetrón de cavidades de alta potencia, que abrió el radar a las microondas y que se cedió a EE. UU. ese otoño.
- *Alemania.* A finales de 1940 tenía tres radares operativos importantes: el de alerta Freya (125 MHz), el de control de tiro Würzburg (565 MHz) y el naval Seetakt (500 MHz), el primer radar militar desplegado operativamente por cualquier país. Probablemente iba por delante de los demás, pero no aprovechó esa ventaja.
- *Unión Soviética.* Los RUS-1 (biestático CW, 75 MHz) dieron paso a los RUS-2 (pulsos monoestáticos, 75 MHz, 150 km de alcance) al comenzar las hostilidades.
- *Italia, Francia, Japón y Países Bajos.* Italia no creyó en el radar hasta su derrota en Cabo Matapán (marzo de 1941). Francia desarrolló especialmente el radar biestático. Japón, pese a descubrir antes el magnetrón, no lo convirtió en radares comparables a los aliados, por el predominio militar sobre los técnicos, el exceso de secreto y la escasez de recursos. Los Países Bajos lograron instalar un radar naval UHF (Type 289) en un barco en combate.

=== El magnetrón y la Segunda Guerra Mundial

El magnetrón de cavidades de alta potencia, inventado en la Universidad de Birmingham, cambió la naturaleza del radar al permitir antenas pequeñas y, con ellas, radares embarcados, aerotransportados y móviles terrestres. EE. UU. fundó en el otoño de 1940 el Laboratorio de Radiación del MIT para desarrollar radar de microondas con el magnetrón británico, y allí se desarrollaron más de 100 sistemas durante la guerra (alerta temprana, control de tiro antiaéreo, interceptación aérea, bombardeo ciego y detección de barcos) [L-18] y [L-19].

=== Después de la guerra

Tras la guerra el desarrollo se centró en lo que no se había completado. El libro enumera los principales logros posteriores [L-19]:

- El perfeccionamiento del radar *MTI* de pulsos, que usa el Doppler para separar aeronaves de los grandes ecos de suelo.
- Amplificadores estables de alta potencia (klistrón, tubo de onda progresiva y transistor), que mejoraron el uso del Doppler, permitieron formas de onda sofisticadas y potencias mucho mayores que el magnetrón.
- El seguimiento angular muy preciso con el radar *monopulso*.
- La *compresión de pulsos*, ya mencionada en la sección de formas de onda.
- El *radar de apertura sintética* aerotransportado (SAR), con imágenes de alta resolución del terreno.
- Los radares aerotransportados con procesado Doppler, que detectan aeronaves en medio de mucho clutter de suelo.
- La antena de *agrupación en fase* de orientación electrónica.
- El radar *transhorizonte de HF*, que multiplicó por diez el alcance de detección de aeronaves hasta casi 2000 nmi.
- La extracción de información del eco para el *reconocimiento de blancos*, de modo que el radar es algo más que un "detector de manchas".
- La aplicación a la meteorología y a la seguridad aérea (precipitación, cizalladura del viento, perfiles verticales de viento).
- Los avances en tecnología digital, que hicieron prácticas muchas capacidades teóricas mediante procesado digital de señal y de datos.

Estas novedades de tecnología, técnicas y aplicaciones han mantenido el crecimiento del radar desde los años treinta.

#callout(kind: "info", title: [PARA EL CAPÍTULO 2])[
  La ecuación (@eq-radar-fundamental) es la base del capítulo 2, que la extiende con factores adicionales (entre ellos la sección radar del blanco y las pérdidas) para que se ajuste mejor a los alcances observados en radares reales [L-7] y [L-30].
]
