#import "@tola/source:0.0.0": tola-meta
#import "/utils/ui.typ": callout, hint, term

#tola-meta((
  title: "[Skolnik 02] La ecuación del radar",
  date: "2026-11-25",
  summary: "Resumen del capítulo 2 de Introduction to Radar Systems (Skolnik, 3.ª ed.): detección en ruido, probabilidades de detección y falsa alarma, integración de pulsos, sección radar, fluctuaciones, pérdidas y forma completa de la ecuación del radar.",
  tags: ("radar", "skolnik", "tfg"),
  series: "Skolnik",
  part: 2,
))

#show math.equation: set text(
  font: "STIX Two Math",
)

#set math.equation(numbering: "(1)")

// Convenio de referencias: [L-D] = libro de Skolnik, 3.ª ed., página impresa D
// (la página del PDF es la impresa + 12).

= La ecuación del radar

== Introducción

=== Del modelo simple al modelo completo

El capítulo 1 dejó la forma simple de la ecuación del radar, que limita la sensibilidad solo por el ruido del receptor:

$ R_"max" = ( (P_t G A_e sigma) / ((4 pi)^2 S_"min") )^(1/4). $ <eq-simple>
// Esta expresión se encuentra en [L-30] (Ec. 2.1, que repite la Ec. 1.7 de [L-6])

Salvo la sección radar $sigma$, todos los parámetros de la @eq-simple los controla el diseñador, y la ecuación indica cómo alcanzar más distancia: más potencia, un haz estrecho, una apertura grande y un receptor sensible [L-30]. El objetivo de este capítulo es completar ese modelo hasta una ecuación utilizable en diseño.

=== Por qué falla la forma simple

En la práctica la @eq-simple no predice bien el rendimiento de un radar real: el alcance observado puede ser la mitad del predicho. El libro atribuye el fallo a cuatro causas [L-31]:

+ La naturaleza estadística de la señal mínima detectable, que suele estar fijada por el ruido del receptor.
+ Las fluctuaciones e incertidumbres de la sección radar del blanco.
+ Las pérdidas a lo largo de todo el sistema.
+ Los efectos de propagación debidos a la superficie terrestre y a la atmósfera.

Las dos primeras causas son aleatorias, y de ello se sigue una consecuencia conceptual importante. El alcance máximo no puede darse con un único número: hay que acompañarlo de la *probabilidad de detección* $P_d$ y de la *probabilidad de falsa alarma* $P_"fa"$. Con ellas, el alcance pasa a ser una función de $P_d$ y $P_"fa"$ [L-31].

Aun así, la ecuación del radar sigue siendo útil para evaluar el rendimiento de un radar, estudiar los compromisos de diseño y redactar los requisitos técnicos de una adquisición, aunque su precisión sea limitada y difícil de verificar experimentalmente [L-31]. En lo que sigue se supone una forma de onda pulsada, salvo que se indique lo contrario, y un rendimiento limitado por el ruido del receptor [L-31].

== Detección de señales en ruido

=== Detección por umbral

La capacidad de un receptor para detectar un eco débil la limita el ruido, que ocupa la misma parte del espectro que la señal. La señal más débil que el receptor puede detectar es la *señal mínima detectable*, denotada $S_"min"$ en la @eq-simple. Su uso no es habitual en radar y, como se verá en la siguiente sección, hay una descripción mejor [L-31].

La detección se basa en fijar un *umbral* a la salida del receptor. Si la salida lo supera, se declara que hay un blanco, y si no, se declara que solo hay ruido. Esto se llama *detección por umbral*. La Fig. 2.1 del libro representa la envolvente de la salida del receptor en función del tiempo, tal como la vería un operador en un A-scope [L-31] y [L-32].

El umbral debe fijarse con cuidado, porque admite dos errores:

- Si es demasiado bajo, el ruido puede superarlo y confundirse con un blanco, lo que se denomina *falsa alarma*.
- Si es demasiado alto, los ecos débiles no lo superan y no se detectan, lo que se denomina *detección perdida*.

La elección del umbral es, por tanto, un compromiso que depende de cuánto importe evitar cada uno de los dos errores. En los primeros radares lo fijaba el juicio del operador sobre una pantalla de rayos catódicos, y en los radares de detección automática se fija con la teoría de la detección clásica que se desarrolla más adelante [L-32] y [L-33].

=== El papel del filtro adaptado

La salida de la Fig. 2.1 se supone procedente de un receptor con *filtro adaptado*, que, como se vio en el capítulo 1, maximiza la relación señal/ruido de salida (Sec. 5.2). Casi todos los radares usan un filtro adaptado o una buena aproximación. Un filtro adaptado no conserva la forma de la señal de entrada: un pulso casi rectangular sale aproximadamente triangular. Esto importa poco, porque el filtro se diseña para maximizar la detectabilidad y no para preservar la forma de onda [L-32].

Considérense los dos ecos débiles de igual amplitud de la figura, B y C. En B el ruido acompañante es positivo y se suma a la señal, de modo que el conjunto supera el umbral y se declara un blanco. En C el ruido es negativo y se resta, de modo que el conjunto no lo supera y la detección se pierde. El ruido puede, pues, favorecer la detección de señales marginales, pero también hacerla fracasar [L-32] y [L-33].

== Ruido del receptor y relación señal/ruido

=== Resultado: sustituir $S_"min"$ por $(S\/N)_"min"$

El resultado de esta sección es la forma de la ecuación del radar en función de la relación señal/ruido mínima, y no de la señal mínima:

$ R_"max"^4 = (P_t G A_e sigma) / ((4 pi)^2 k T_0 B F_n (S\/N)_"min"). $ <eq-radar-sn>
// Esta expresión se encuentra en [L-34] (Ec. 2.8)

Aquí $k$ es la constante de Boltzmann, $T_0$ la temperatura estándar, $B$ el ancho de banda del receptor y $F_n$ su figura de ruido. El libro escribe el alcance elevado a la cuarta potencia a la izquierda por comodidad. La ventaja de $(S\/N)_"min"$ es que es independiente del ancho de banda y de la figura de ruido del receptor y, como se verá en la sección de probabilidades, puede expresarse en función de $P_d$ y $P_"fa"$, dos parámetros que se relacionan con las necesidades del usuario [L-34]. La relación señal/ruido de la @eq-radar-sn es la de la salida de la FI, porque maximizarla ahí equivale a maximizarla en la salida de vídeo, donde se decide con el umbral [L-35].

=== Ruido térmico

A frecuencias de microondas, el ruido con el que compite el eco suele generarlo el propio receptor. Incluso en un entorno libre de fuentes externas de ruido y con un receptor perfecto, queda el *ruido térmico* o *ruido de Johnson*, debido a la agitación térmica de los electrones de conducción en las partes óhmicas de las etapas de entrada. Su potencia disponible en un receptor de ancho de banda $B_n$ (en Hz) a la temperatura $T$ (en K) es

$ N = k T B_n, $ <eq-ruido-termico>
// Esta expresión se encuentra en [L-33] (Ec. 2.2)

con $k = 1.38 dot 10^(-23) "J/K"$. El adjetivo "disponible" indica que el dispositivo funciona con la entrada y la carga adaptadas [L-33]. La potencia crece linealmente con el ancho de banda y con la temperatura, lo que se emplea al diseñar la FI.

El *ancho de banda de ruido* $B_n$ es el del filtro rectangular equivalente que da la misma potencia de ruido a la salida que el filtro real de respuesta $H(f)$:

$ B_n = (integral_(-oo)^(oo) |H(f)|^2 dif f) / (|H(f_0)|^2), $ <eq-ancho-ruido>
// Esta expresión se encuentra en [L-33] (Ec. 2.3)

con $f_0$ la frecuencia de máxima respuesta (normalmente en banda media). No coincide con el ancho de banda de media potencia (3 dB), pero este es una buena aproximación en muchos receptores prácticos, y en el resto del capítulo se usa el ancho de banda de media potencia $B$ en lugar de $B_n$ [L-33] y [L-34].

=== Figura de ruido

El ruido de un receptor real es mayor que el térmico. La *figura de ruido* mide el cociente entre el ruido a la salida del receptor práctico y el de un receptor ideal a la temperatura estándar $T_0$:

$ F_n = N_"out" / (k T_0 B G_a) = (S_"in" \/ N_"in") / (S_"out" \/ N_"out"). $ <eq-figura-ruido>
// Esta expresión se encuentra en [L-34] (Ecs. 2.4 y 2.5)

El IEEE define $T_0 = 290 "K"$, y con ella $k T_0 = 4 dot 10^(-21) "W/Hz"$, un valor más fácil de recordar que la constante de Boltzmann. La ganancia disponible $G_a = S_"out" \/ S_"in"$ es el cociente entre la señal de salida y la de entrada con ambas adaptadas, y el ruido de entrada de un receptor ideal es $N_"in" = k T_0 B$, lo que justifica la igualdad de la @eq-figura-ruido. Con esta segunda forma, la figura de ruido mide la degradación de la relación señal/ruido al atravesar el receptor [L-34].

=== Deducción

Se obtiene la @eq-radar-sn despejando la señal de entrada en la @eq-figura-ruido y sustituyendo después $S_"min"$ en la ecuación simple. Primero se despeja:

$ S_"in" = k T_0 B F_n S_"out" / N_"out". $ <eq-sin>
// Esta expresión se encuentra en [L-34] (Ec. 2.6)

Si $S_"min"$ es el valor de $S_"in"$ que corresponde a la relación señal/ruido mínima detectable a la salida de la FI, entonces

$ S_"min" = k T_0 B F_n ( S_"out" / N_"out" )_"min". $ <eq-smin>
// Esta expresión se encuentra en [L-34] (Ec. 2.7)

Sustituir la @eq-smin en la @eq-simple, y omitir los subíndices de $S$ y $N$, da la @eq-radar-sn [L-34].

#callout(kind: "info", title: [ANCHO DE BANDA Y PRODUCTO $B tau$])[
  El capítulo 1 mostró que un filtro cercano al adaptado cumple $B tau approx 1$. En la @eq-radar-sn el ancho de banda y la figura de ruido aparecen explícitamente en el denominador, de modo que, a igual $(S\/N)_"min"$, un receptor de mayor ancho de banda o más ruidoso tiene menos alcance. Esta lectura es una consecuencia directa de la ecuación y no figura en el libro.
]

== Funciones de densidad de probabilidad

Esta sección repasa lo necesario para describir estadísticamente el ruido y la señal; el libro avisa de que quien conozca el tema puede omitirla [L-35].

=== Definición y propiedades

El ruido es un fenómeno aleatorio, y la detección en presencia de ruido también. Las probabilidades toman valores entre 0 (suceso imposible) y 1 (suceso cierto), y describen sucesos discretos. Las magnitudes continuas, como el ruido, se describen con una *función de densidad de probabilidad* (pdf) $p(x)$. Dada una variable aleatoria $x$ (por ejemplo, una tensión de ruido), la probabilidad de que $x$ caiga en un intervalo finito se obtiene integrando la pdf:

$ P(x_1 < x < x_2) = integral_(x_1)^(x_2) p(x) dif x. $ <eq-prob-intervalo>
// Esta expresión se encuentra en [L-35] (Ec. 2.10)

La pdf es siempre no negativa, y como toda medida produce algún valor, su integral sobre todos los valores debe valer la unidad:

$ integral_(-oo)^(oo) p(x) dif x = 1. $ <eq-normalizacion>
// Esta expresión se encuentra en [L-35] (Ec. 2.11)

El valor medio de una función $phi(x)$ de la variable es $integral phi(x) p(x) dif x$ (extendida a todos los valores). De ahí, el valor medio $m_1$ de $x$ y su valor cuadrático medio $m_2$ son el primer y el segundo momento:

$ m_1 = integral_(-oo)^(oo) x p(x) dif x, quad m_2 = integral_(-oo)^(oo) x^2 p(x) dif x. $ <eq-momentos>
// Estas expresiones se encuentran en [L-36] (Ecs. 2.13 y 2.14)

Si $x$ es una tensión o una corriente, $m_1$ es la componente continua y $m_2$, multiplicado por la resistencia, la potencia media (en teoría de la detección se toma una resistencia de 1 $Omega$, de modo que $m_2$ se llama potencia media). La *varianza* es la desviación cuadrática media respecto de la media:

$ sigma^2 = integral_(-oo)^(oo) (x - m_1)^2 p(x) dif x = m_2 - m_1^2, $ <eq-varianza>
// Esta expresión se encuentra en [L-36] (Ec. 2.15)

y su raíz cuadrada, la *desviación típica* $sigma$, es el valor eficaz (rms) de la componente alterna [L-36]. La *función de distribución* se relaciona con la pdf mediante $P(x) = integral_(-oo)^x p(u) dif u$, o de forma equivalente $p(x) = dif P \/ dif x$ [L-38].

#hint[Esta $sigma$ es la desviación típica de una variable aleatoria y no la sección radar. El libro reutiliza el símbolo; en esta entrada, el contexto indica cuál es en cada caso.]

=== Cuatro ejemplos

- La pdf *uniforme* vale una constante $k$ en un intervalo $[a, a + b]$ y cero fuera. La normalización exige $k = 1 \/ b$, la media es $a + b \/ 2$ y la varianza $b^2 \/ 12$. Describe, por ejemplo, la fase de una sinusoide aleatoria entre 0 y $2 pi$ y el error de cuantificación [L-36].
- La pdf *gaussiana* describe muchas fuentes de ruido, entre ellas el ruido térmico del receptor, y es manejable matemáticamente. Su expresión es
  $ p(x) = 1 / sqrt(2 pi sigma^2) exp( - (x - x_0)^2 / (2 sigma^2) ), $ <eq-gauss>
  con media $x_0$ y varianza $sigma^2$. Su relevancia se debe al teorema del límite central: bajo hipótesis muy generales, la pdf de la suma de muchas magnitudes independientes tiende a la gaussiana, sean cuales sean las pdf individuales [L-36] y [L-37].
- La pdf de *Rayleigh* es la de la envolvente de un filtro de banda estrecha, como el de FI del receptor, cuando su entrada es una tensión de ruido gaussiana:
  $ p(x) = (2 x) / m_2 exp( - x^2 / m_2 ), quad x >= 0, $ <eq-rayleigh>
  con $m_2$ el valor cuadrático medio de $x$. Depende de un único parámetro y su desviación típica es $sqrt(4 / pi - 1) approx 0.523$ veces su media. También ajusta la estadística de la sección radar de algunos blancos y del clutter [L-37].
- La pdf *exponencial* resulta de sustituir $x^2$ por $w$ en la de Rayleigh:
  $ p(w) = 1 / w_0 exp( - w / w_0 ), quad w >= 0, $ <eq-exponencial>
  con $w_0$ el valor medio de $w$. Si $x$ es la tensión, $w$ es la potencia y $w_0$ la potencia media, por lo que también se llama pdf de Rayleigh de potencia. Su desviación típica es igual a su media [L-38].
// Estas expresiones se encuentran en [L-36] a [L-38] (Ecs. 2.16 a 2.18)

Más adelante aparecerán las pdf de Rice, logarítmico-normal y chi cuadrado como modelos de la sección radar [L-38].

=== Ejemplo: rectificador de media onda

Como ilustración del método (hallar la pdf de salida a partir de la de entrada), el libro calcula la componente continua de la salida de un rectificador de media onda ($y = a x$ si $x >= 0$, $y = 0$ si $x < 0$) cuando la entrada es ruido gaussiano de media cero y desviación típica $sigma$. La pdf de salida tiene tres partes: la propia gaussiana para $y > 0$, una delta de peso $1 \/ 2$ en $y = 0$ (la mitad del tiempo el ruido es negativo) y cero para $y < 0$. La media de salida es

$ m_1 = a sigma / sqrt(2 pi). $
// Este resultado se encuentra en [L-39]

El resultado interesa poco por sí mismo, pero el procedimiento es el de la sección siguiente, donde solo se darán las respuestas [L-38] y [L-39].

== Probabilidades de detección y de falsa alarma

=== Resultado y plan

Esta sección calcula la mínima relación señal/ruido que garantiza una $P_d$ dada con una $P_"fa"$ dada, que es lo que se sustituye en la @eq-radar-sn. La idea es la siguiente: el umbral se fija a partir de la $P_"fa"$ (o del tiempo entre falsas alarmas), y con ese umbral la $P_d$ depende de la relación señal/ruido. Eliminando el umbral entre ambas relaciones, se obtiene una única relación entre $P_d$, $P_"fa"$ y $(S\/N)$ [L-39] y [L-44].

=== Detector de envolvente

La parte del receptor donde se decide es la de la Fig. 2.3: el amplificador de FI de ancho de banda $B_"IF"$, el segundo detector, el amplificador de vídeo y el umbral. El filtro de FI, el segundo detector y el filtro de vídeo forman un *detector de envolvente*, cuya salida es la envolvente (la modulación) de la señal de FI. Para ello hacen falta un ancho de banda de vídeo al menos igual a la mitad del de FI y una frecuencia central de FI mucho mayor que el ancho de banda, condiciones que suelen cumplirse. Es indiferente, a efectos de la probabilidad de detección, que el detector sea lineal o cuadrático. El primero se prefiere en la práctica porque admite mayor margen dinámico, y el segundo es más sencillo de tratar matemáticamente [L-39] y [L-40].

=== Probabilidad de falsa alarma

El ruido a la entrada del filtro de FI es gaussiano de media cero y potencia media $psi_0$ (@eq-gauss con $x_0 = 0$ y $sigma^2 = psi_0$). Rice demostró que, tras el filtro de FI, la envolvente $R$ sigue una pdf de Rayleigh:

$ p(R) = R / psi_0 exp( - R^2 / (2 psi_0) ), quad R >= 0. $ <eq-env-ruido>
// Esta expresión se encuentra en [L-40] (Ecs. 2.20 y 2.21)

Hay falsa alarma cuando la envolvente del ruido supera el umbral $V_T$. Su probabilidad es la integral de la @eq-env-ruido de $V_T$ a infinito:

$ P_"fa" = integral_(V_T)^(oo) R / psi_0 exp( - R^2 / (2 psi_0) ) dif R = exp( - V_T^2 / (2 psi_0) ). $ <eq-pfa>
// Esta expresión se encuentra en [L-40] (Ecs. 2.22 y 2.23)

La probabilidad por sí sola dice poco sobre si un radar sufrirá demasiadas falsas alarmas. Una medida más cercana al usuario es el *tiempo de falsa alarma* $T_"fa"$, promedio del tiempo $T_k$ entre cruces del umbral por el ruido solo:

$ T_"fa" = lim_(N -> oo) 1 / N sum_(k=1)^N T_k. $ <eq-tfa>
// Esta expresión se encuentra en [L-41] (Ec. 2.24)

Relacionando ambas: la probabilidad de falsa alarma es el cociente entre el tiempo que la envolvente está efectivamente sobre el umbral y el tiempo total en que podría estarlo. La duración media de un cruce, $overline(t)$, es aproximadamente la inversa del ancho de banda de FI, $1 \/ B$. De ahí

$ P_"fa" = overline(t) / T_"fa" approx 1 / (T_"fa" B). $ <eq-pfa-tfa>
// Esta expresión se encuentra en [L-41] (Ec. 2.25)

Igualar la @eq-pfa y la @eq-pfa-tfa y despejar $T_"fa"$ da

$ T_"fa" = 1 / B exp( V_T^2 / (2 psi_0) ). $ <eq-tfa-umbral>
// Esta expresión se encuentra en [L-41] (Ec. 2.26)

#callout(kind: "info", title: [EJEMPLO NUMÉRICO DEL LIBRO])[
  Con $B = 1 "MHz"$ y un tiempo medio entre falsas alarmas de 15 min ($= 900 "s"$), la @eq-pfa-tfa da $P_"fa" = 1 \/ (900 dot 10^6) = 1.11 dot 10^(-9)$. Entonces, por la @eq-pfa, $V_T^2 \/ (2 psi_0) = ln(1 \/ P_"fa") approx 20.6$, es decir, un umbral 16.2 dB por encima de la potencia media de ruido ($V_T$ es 6.42 veces el valor eficaz del ruido) [L-41] y [L-42].

  La @eq-tfa-umbral es exponencial en el umbral, por lo que $T_"fa"$ es muy sensible a pequeñas variaciones de este. Con $B = 1 "MHz"$ y $10 log (V_T^2 \/ 2 psi_0) = 13.2 "dB"$, $T_"fa"$ es unos 20 min, y bajar el umbral 0.5 dB (a 12.7 dB) lo reduce a unos 2 min, un orden de magnitud [L-42] y [L-43].
]

Las probabilidades de falsa alarma de un radar son muy pequeñas porque se toma una decisión cada $1 \/ B$ segundos: con $B = 1 "MHz"$ hay un millón de decisiones por segundo, y una falsa alarma por segundo equivale a $P_"fa" = 10^(-6)$ [L-42].

Conviene precisar tres cuestiones. Primero, las falsas alarmas reales proceden más a menudo del clutter (suelo, mar, meteoros, aves, insectos) que del ruido térmico, aunque en las especificaciones solo se considera el ruido del receptor [L-43]. Segundo, un cruce del umbral no es necesariamente un informe de blanco falso, porque declarar un blanco suele exigir varias detecciones y, a veces, establecer una pista, lo que permite una $P_"fa"$ mayor por detección (Sec. 2.13) [L-43]. Tercero, apagar el receptor durante la transmisión del pulso eleva la probabilidad de falsa alarma en la fracción de tiempo en que está inactivo, un efecto que rara vez es necesario considerar [L-43].

=== Probabilidad de detección

Sea ahora una señal sinusoidal de amplitud $A$ más ruido gaussiano a la entrada del detector de envolvente. La pdf de la envolvente $R$ es la de Rice:

$ p_s(R) = R / psi_0 exp( - (R^2 + A^2) / (2 psi_0) ) I_0 ( (R A) / psi_0 ), quad R >= 0, $ <eq-rice>
// Esta expresión se encuentra en [L-43] (Ec. 2.27)

donde $I_0$ es la función de Bessel modificada de orden cero. Para $A = 0$ la @eq-rice se reduce a la @eq-env-ruido, como corresponde a la ausencia de señal. La probabilidad de detección es la probabilidad de que la envolvente supere el umbral fijado por la $P_"fa"$ exigida:

$ P_d = integral_(V_T)^(oo) p_s(R) dif R. $ <eq-pd>
// Esta expresión se encuentra en [L-43] (Ec. 2.29)

Esta integral no se evalúa por métodos simples. Rice usó un desarrollo en serie, y se han empleado también métodos numéricos y empíricos [L-43]. En análisis de sistemas conviene la relación señal/ruido en potencia, que se relaciona con la amplitud mediante $A^2 \/ (2 psi_0) = S \/ N$, ya que $A^2 \/ 2$ es la potencia de la señal y $psi_0$ la del ruido [L-44].

=== Relación entre $P_d$, $P_"fa"$ y $S\/N$

La @eq-pfa y la @eq-pd son funciones del cociente umbral/ruido $V_T^2 \/ 2 psi_0$. Eliminándolo entre ambas se tiene una relación entre $P_d$, $P_"fa"$ y $S\/N$, que se representa en la Fig. 2.6 del libro [L-44]. Albersheim obtuvo una fórmula empírica sencilla para la relación señal/ruido (en veces, no en dB):

$ S / N = A + 0.12 A B + 1.7 B, quad A = ln(0.62 / P_"fa"), quad B = ln( P_d / (1 - P_d) ). $ <eq-albersheim>
// Esta expresión se encuentra en [L-44] (Ec. 2.30)

El libro da para la @eq-albersheim un error menor de 0.2 dB para $0.1 <= P_d <= 0.9$ y $10^(-7) <= P_"fa" <= 10^(-3)$ [L-45]. Con el ejemplo anterior ($P_"fa" = 1.11 dot 10^(-9)$), la Fig. 2.6 da relaciones señal/ruido de 13.05 dB para $P_d = 0.5$, 14.7 dB para $P_d = 0.9$ y 15.75 dB para $P_d = 0.99$. Menos de 3 dB separan, por tanto, una detección muy fiable (0.99) de una marginal (0.50) [L-45]. Como comprobación (no figura en el libro), la @eq-albersheim da $A = 20.14$, y de ella 13.04 dB, 14.65 dB y 15.92 dB para esos tres valores de $P_d$, en acuerdo con la figura dentro de la tolerancia citada.

Las relaciones señal/ruido de 13 a 16 dB parecen altas, pero resultan de exigir, en media, una falsa alarma cada 900 millones de decisiones posibles. En comparación con las telecomunicaciones (televisión, unos 40 dB; telefonía, 50 dB) los valores del radar son bajos [L-45]. Todo lo anterior vale para un solo pulso.

== Integración de pulsos radar

=== Resultado e idea principal

Un radar suele disponer de varios pulsos del mismo blanco. Sumarlos, o *integrarlos*, aumenta la relación señal/ruido y reduce el valor necesario por pulso. El número de pulsos recibidos de un blanco puntual por un radar que explora es

$ n = (theta_B f_p) / dot(theta)_s = (theta_B f_p) / (6 omega_m), $ <eq-hits>
// Esta expresión se encuentra en [L-45] (Ec. 2.31)

con $theta_B$ el ancho de haz (en grados), $dot(theta)_s$ la velocidad de barrido (en grados por segundo) y $omega_m$ las revoluciones por minuto de una antena que gira 360°, ya que $dot(theta)_s = 6 omega_m$. Es el número de pulsos dentro del ancho de haz unidireccional, llamado "golpes por barrido" (_hits per scan_). Por ejemplo, un radar terrestre de vigilancia aérea de largo alcance con $f_p = 340 "Hz"$, $theta_B = 1.5°$ y 5 rpm ($30 "°/s"$) recibe $n = 1.5 dot 340 \/ 30 = 17$ pulsos por barrido [L-45].

=== Integración coherente y no coherente

La integración que se hace en el receptor antes del segundo detector (en FI) es la *integración predetección* o *coherente*. En teoría no tiene pérdidas, pero exige conocer y conservar la fase de los pulsos para sumarlos en fase. La que se hace tras el segundo detector es la *integración postdetección* o *no coherente*: es más fácil, porque solo hay que alinear las envolventes, pero tiene pérdida teórica, causada por la acción no lineal del detector, que convierte parte de la energía de señal en ruido [L-46].

Sea $(S\/N)_1$ la relación señal/ruido de un solo pulso para la detección buscada. Si $n$ pulsos iguales se integran idealmente sin pérdida y en predetección, la relación resultante es exactamente $n$ veces la de un pulso, y la relación exigida por pulso pasa a ser $(S\/N)_n = (S\/N)_1 \/ n$. Con integración postdetección el resultado es menor que $n$ veces, y esto se recoge con la *eficiencia de integración*:

$ E_i (n) = (S\/N)_1 / (n (S\/N)_n). $ <eq-eficiencia>
// Esta expresión se encuentra en [L-46] (Ec. 2.32)

La mejora de relación señal/ruido al integrar $n$ pulsos, $I(n) = n E_i (n)$, es el *factor de mejora de integración*, y se interpreta como el número equivalente de pulsos integrados $n_"eq" = n E_i (n)$. Con integración predetección ideal, $n_"eq" = n$; con postdetección, $n_"eq" < n$. Marcum definió la pérdida de integración, en dB, como $L_i (n) = 10 log(1 \/ E_i (n))$. Sus resultados (Fig. 2.7) dependen poco de $P_d$ y $P_"fa"$ [L-46] y [L-47]. Con pocos pulsos integrados (relación por pulso alta), postdetección y predetección rinden casi igual, y la diferencia crece con muchos pulsos (relación por pulso baja) [L-48].

#callout(kind: "note", title: [NÚMERO DE FALSA ALARMA Y SUS CONVENIOS])[
  Marcum emplea el *número de falsa alarma* $n_f$, el inverso de la probabilidad de falsa alarma. Como $tau approx 1 \/ B$, el número de decisiones posibles en el tiempo $T_"fa"$ es $n_f = T_"fa" B = 1 \/ P_"fa"$ [L-47] y [L-48]. Al integrar $n$ pulsos el radar decide a velocidad $B \/ n$, lo que multiplica por $n$ la probabilidad de falsa alarma, pero no el número de falsas alarmas, porque se supone constante el tiempo medio entre ellas. El libro sigue a Marcum y toma $P_"fa" = 1 \/ n_f$ incluso al integrar. Algunos autores definen $n'_f = n_f \/ n$, y por ello conviene verificar los supuestos de cada fuente o programa antes de usar sus relaciones señal/ruido [L-48].
]

Una nota histórica del libro: en los primeros radares se creyó que un operador mirando un PPI lograba una mejora de integración $n^(1 \/ 2)$. Esa relación se basaba en una teoría incorrecta y en pantallas deficientes, y con pulsos presentados sin solaparse ni saturar la pantalla, el operador puede igualar la teoría de Marcum [L-48].

=== La ecuación del radar con integración

Con $n$ pulsos integrados la ecuación del radar es

$ R_"max"^4 = (P_t G A_e sigma) / ((4 pi)^2 k T_0 B F_n (S\/N)_n), $ <eq-radar-n>
// Esta expresión se encuentra en [L-48] (Ec. 2.33)

donde $(S\/N)_n$ es la relación por pulso de los $n$ pulsos iguales integrados y $B$ el ancho de banda de media potencia. Sustituir $(S\/N)_n$ de la @eq-eficiencia da la forma que se usa en la práctica, que solo necesita las Figs. 2.6 y 2.7 (para $(S\/N)_1$ y para $n E_i (n)$):

$ R_"max"^4 = (P_t G A_e sigma n E_i (n)) / ((4 pi)^2 k T_0 B F_n (S\/N)_1). $ <eq-radar-ei>
// Esta expresión se encuentra en [L-49] (Ec. 2.34)

Para $(S\/N)_n$ existe también una aproximación empírica de Albersheim, extensión de la @eq-albersheim:

$ (S\/N)_(n, "dB") = -5 log_10 n + [ 6.2 + 4.54 / sqrt(n + 0.44) ] log_10 (A + 0.12 A B + 1.7 B), $ <eq-albersheim-n>
// Esta expresión se encuentra en [L-49] (Ec. 2.35); $A$ y $B$ son los de la @eq-albersheim

con error menor de 0.2 dB para $1 <= n <= 8096$, $0.1 <= P_d <= 0.9$ y $10^(-7) <= P_"fa" <= 10^(-3)$ [L-49]. Como comprobación propia (no figura en el libro), para $n = 1$ el corchete vale $6.2 + 4.54 \/ sqrt(1.44) = 9.98 approx 10$, de modo que la @eq-albersheim-n se reduce, salvo ese pequeño desajuste, a $10 log_10$ de la @eq-albersheim.

Todo lo anterior es pérdida teórica. Puede haber pérdidas adicionales por el método concreto de integración [L-49].

== Sección radar de blancos

=== Definición y regiones de dispersión

La *sección radar* $sigma$ es la propiedad del blanco que cuantifica en la ecuación del radar la magnitud del eco que devuelve. En el capítulo 1 se definió mediante la densidad de potencia reirradiada hacia el radar. Una definición equivalente, habitual en electromagnetismo, es

$ sigma = 4 pi R^2 (|E_r|^2 )/ (|E_i|^2), $ <eq-rcs-def>
// Esta expresión se encuentra en [L-49] (Ec. 2.36)

con $R$ la distancia al blanco, $E_r$ el campo eléctrico del eco en el radar y $E_i$ el campo incidente en el blanco. Se supone el blanco lo bastante lejos como para que la onda incidente sea plana. A veces se interpreta $sigma$ como un área ficticia que intercepta parte de la potencia incidente y, reirradiada uniformemente en todas las direcciones, produce en el radar el mismo eco que el blanco real, que sin embargo no dispersa uniformemente [L-49] y [L-50].

La sección radar puede calcularse resolviendo las ecuaciones de Maxwell con las condiciones de contorno adecuadas, mediante modelos por ordenador, o medirse con la propia ecuación del radar, con blancos a escala real o reducida [L-50]. Depende de las dimensiones características del objeto en comparación con la longitud de onda, lo que define tres regiones:

- La *región de Rayleigh* (longitud de onda grande frente al objeto): $sigma$ es proporcional a la cuarta potencia de la frecuencia y depende más del volumen que de la forma. Es la que describe el eco de la lluvia.
- La *región óptica* (longitud de onda pequeña frente al objeto): $sigma$ varía mucho con la frecuencia y el ángulo de observación, y depende más de la forma que del área proyectada. Es la región de aviones y barcos a frecuencias de microondas.
- La *región de resonancia*, intermedia, donde la longitud de onda es comparable a las dimensiones del objeto y $sigma$ suele ser mayor que en las otras dos.
// Estas regiones se encuentran en [L-50]

=== Blancos simples

La sección radar de blancos complejos puede calcularse a veces descomponiéndolos en formas simples de sección conocida y sumando vectorialmente sus contribuciones [L-50]. Los ejemplos clásicos son los siguientes.

- *Esfera.* Es el caso más sencillo, porque tiene la misma forma desde cualquier aspecto. En función de $2 pi a \/ lambda$ (circunferencia en longitudes de onda, con $a$ el radio), la sección normalizada por el área proyectada $pi a^2$ pasa por las tres regiones (Fig. 2.8). En la región de Rayleigh ($2 pi a \/ lambda << 1$), $sigma prop f^4$. En la región óptica ($2 pi a \/ lambda >> 1$), $sigma$ tiende a $pi a^2$ al aumentar la frecuencia. Esta coincidencia es única de la esfera y no debe inducir a creer que el área geométrica mide la sección de otros blancos. En la región de resonancia, $sigma$ oscila con la frecuencia: el máximo ocurre en $2 pi a \/ lambda = 1$ y está 5.6 dB por encima del valor óptico, y el primer nulo está 5.5 dB por debajo. La oscilación se debe a la interferencia entre la reflexión especular del frente y la *onda de superficie* (_creeping wave_) que rodea la parte trasera, y su amplitud decae al aumentar la frecuencia porque la onda de superficie se atenúa más cuanto mayor es su camino eléctrico. La esfera es el único blanco simple cuya sección no depende del aspecto ni de la polarización [L-50] a [L-52].
- *Hilo o varilla largos.* Visto de lado ($theta = 90°$) tiene sección grande, que decrece deprisa al separarse de esa dirección, como predice la óptica física. Pero con ángulos pequeños el eco vuelve a crecer por una *onda de superficie* que la teoría de óptica física no predice: la onda incidente se acopla al hilo, lo recorre y se refleja en la discontinuidad del extremo. Aparece también en placas, ogivas y alas, y solo se excita si el campo eléctrico tiene componente en el plano de incidencia, lo que ocurre con polarización vertical y no con horizontal. Se reduce con materiales resistivos que la atenúan [L-52] y [L-53].
- *Placa plana y reflector en esquina.* Con incidencia normal, la sección de una placa de área $A$ en la región óptica es

  $ sigma = (4 pi A^2) / lambda^2. $ <eq-placa>
  // Esta expresión se encuentra en [L-53]

  Puede ser muy grande para una placa modesta: a 3 cm (banda X), una placa cuadrada de 0.3 m de lado ($A = 0.09 "m"^2$) tiene $sigma = 4 pi dot 0.09^2 \/ 0.03^2 approx 113 "m"^2$. La expresión vale también para un reflector diedro o triedro de área proyectada $A$, con la diferencia de que se cumple en un margen angular mucho mayor [L-53] y [L-54]. Una placa es una estructura simple pero de dispersión compleja: la sección medida cae deprisa al apartarse de la normal y, lejos de ella, aparece un término de onda de superficie que las teorías no reproducen [L-54].
- *Cono-esfera.* Es un cono rematado en una esfera con derivada continua en la unión. Su sección es muy baja desde la punta hasta casi la incidencia normal sobre el cono (por eso se ha usado en vehículos de reentrada y en blancos de baja observabilidad), y grande si se ve por detrás (como una esfera) o perpendicularmente a la superficie del cono. Una estimación cómoda en incidencia frontal, cuando importa más la sencillez que la exactitud, es $sigma approx 0.1 lambda^2$. Los ecos proceden de la punta, de la unión cono-esfera y de la onda de superficie. En la práctica, el redondeo de la punta, la rugosidad y la imprecisión de contorno hacen que la sección deje de disminuir con la frecuencia y hasta aumente a longitudes de onda pequeñas [L-54] a [L-56].

La forma pesa más que el tamaño. A 3 GHz ($lambda = 0.1 "m"$), un reflector en esquina o una placa de 1 $"m"^2$ de área tiene $sigma$ cercana a 1000 $"m"^2$ (por la @eq-placa, $4 pi \/ 0.01 approx 1257$), mientras que un cono-esfera con 1 $"m"^2$ de área proyectada tiene, según la aproximación anterior, $0.1 lambda^2 = 0.001 "m"^2$. Esa diferencia de un millón a uno ocurre con la misma área proyectada [L-56].

=== Blancos complejos

La sección radar de aviones, misiles, barcos, vehículos, estructuras y terreno varía mucho con el aspecto y la frecuencia, porque se compone de numerosos dispersores individuales. Cada uno produce un eco con amplitud y fase propias, y el eco total es su suma en el radar. Cambiar el aspecto o la frecuencia modifica las fases relativas, y con ellas la suma [L-56].

El caso más simple es el de dos dispersores iguales de sección $sigma_0$ separados una distancia $l$, vistos con un ángulo $theta$ respecto de la normal a la línea que los une. La sección resultante $sigma_r$ es

$ sigma_r / sigma_0 = 2 [ 1 + cos( (4 pi l) / lambda sin(theta) ) ]. $ <eq-dos-dispersores>
// Esta expresión se encuentra en [L-57] (Ec. 2.37)

Varía entre un mínimo de cero y un máximo de $4 sigma_0$, y al crecer la separación en longitudes de onda los lóbulos se hacen más estrechos y numerosos (Fig. 2.14). El máximo de $4 sigma_0$ (y no de $2 sigma_0$) se debe a que se suman los campos y no las potencias: dos ecos en fase duplican la amplitud y cuadruplican la potencia. Los blancos prácticos reúnen muchos dispersores con propiedades distintas e interacciones entre ellos, como las reflexiones múltiples de un reflector en esquina [L-57].

#callout(kind: "info", title: [AVIONES, BARCOS Y OTROS BLANCOS])[
  *Aviones.* El B-26 medido a 3 GHz presentaba cambios de hasta 15 dB para una variación de aspecto de solo un tercio de grado, y el máximo del eco aparecía cerca del costado. En un reactor, el eco frontal lo determinan sobre todo los motores y sus conductos de admisión; cerca del costado, el fuselaje, las góndolas y el estabilizador vertical; y desde atrás, los bordes de salida de las alas y los conductos de escape. Una maqueta 1:15 de un Boeing 737 medida a 10 GHz se traslada a escala real (667 MHz) sumando 23.5 dB, valor que coincide con $20 log_10 15$ y es coherente con el cambio de escala de la sección con el cuadrado de las longitudes (comprobación propia). La sección de un avión puede fluctuar hasta unos 60 dB, y su valor medio en microondas no cambia mucho con la frecuencia; a frecuencias menores suele ser mayor (unas cinco veces más en VHF que en banda L para un avión de hélice militar, y más de un orden de magnitud en HF) [L-57] a [L-61].

  *Barcos.* Una regla empírica dice que la sección en $"m"^2$ es aproximadamente el desplazamiento en toneladas, válida con ángulos de rasante no cercanos a cero. Con rasante casi nulo, la mediana es

  $ sigma = 52 f^(1 \/ 2) D^(3 \/ 2), $ <eq-barcos>
  // Esta expresión se encuentra en [L-61] (Ec. 2.38)

  con $sigma$ en $"m"^2$, $f$ en MHz y $D$ el desplazamiento a plena carga en kilotoneladas (base de medida: bandas X, S y L; 2000 a 17 000 t, promediando proas y cuartas, sin el máximo del costado). Con rasante nulo las secciones son mucho mayores, porque la superestructura presenta superficies verticales y esquinas [L-61] y [L-62].

  *Otros.* Un automóvil visto de frente tiene entre 10 y 200 $"m"^2$ en banda X (100 $"m"^2$ típico), una lancha de recreo de 20 a 30 pies unos pocos $"m"^2$ y un hombre entre 0.03 y 1.9 $"m"^2$, con 1 $"m"^2$ como valor "típico". Los datos de blancos militares operativos rara vez se publican [L-62] a [L-64].
]

=== Valores de ejemplo

Una sola cifra no describe completamente la sección radar de un blanco, pues varía con aspecto, frecuencia y polarización, pero a veces se necesita un valor representativo de una clase. La @tab-rcs recoge los del libro, sin especificar si son medias, medianas o valores excedidos con cierta probabilidad, porque no hay un método único acordado para ello [L-64].

#figure(
  table(
    columns: 2,
    table.header[Blanco][$sigma$ ($"m"^2$)],
    [Pequeña aeronave monomotor], [1],
    [Caza pequeño o reactor de cuatro pasajeros], [2],
    [Caza grande], [6],
    [Bombardero medio o reactor comercial medio], [20],
    [Bombardero grande o reactor comercial grande], [40],
    [Reactor jumbo], [100],
    [Helicóptero], [3],
    [Lancha abierta pequeña], [0.02],
    [Lancha de recreo (20–30 pies)], [2],
    [Yate de cabina (40–50 pies)], [10],
    [Automóvil], [100],
    [Furgoneta], [200],
    [Bicicleta], [2],
    [Hombre], [1],
  ),
  caption: [Valores de ejemplo de sección radar en microondas, seleccionados de la Tabla 2.1 de [L-64]. Cada clase admite grandes variaciones.],
) <tab-rcs>
// Esta tabla se encuentra en [L-64]; se omiten misiles, barcos, aves e insectos

== Fluctuaciones de la sección radar

=== Modelo de dispersores puntuales

Pequeños cambios de aspecto pueden alterar mucho la sección de un blanco complejo. Si este se representa como un conjunto de $N$ dispersores puntuales independientes, el eco es

$ s_r (t) = sum_(i=1)^N a_i sin(2 pi f t + phi_i) = A sin(2 pi f t + Phi), $ <eq-dispersores>
// Esta expresión se encuentra en [L-65] (Ec. 2.39)

con $a_i$ la amplitud del dispersor $i$-ésimo y $phi_i = 2 pi f T_i$ su fase, siendo $T_i$ el tiempo de ida y vuelta a ese dispersor y $f$ la frecuencia del radar. La amplitud y la fase del eco total son

$ A = ( (sum_i a_i sin(phi_i))^2 + (sum_i a_i cos(phi_i))^2 )^(1 \/ 2), quad Phi = arctan( (sum_i a_i sin(phi_i)) / (sum_i a_i cos(phi_i)) ). $
// Esta expresión se encuentra en [L-65]

El modelo es sencillo y tiene límites: ignora las reflexiones múltiples y el sombreado de unos dispersores por otros, y supone la distancia mucho mayor que la extensión del blanco, de modo que la variación $R^(-4)$ de la potencia no afecta a cada dispersor por separado. Si cambia el aspecto, cambian las distancias a los dispersores y, con ellas, los $T_i$. Un desfase relativo superior a $2 pi$ rad modifica de manera apreciable la fase y la amplitud del eco total, y eso produce las *fluctuaciones* de la sección (en la literatura, también "desvanecimiento", _fading_) [L-65].

Una forma simple de tenerlas en cuenta es usar un valor pequeño de sección que se supere casi siempre. Es sencilla pero imprecisa, al igual que los métodos analíticos que requieren conocer las estadísticas reales. El método habitual para hallar la relación señal/ruido mínima con sección no constante se basa en la pdf de las fluctuaciones, y además hay que conocer su correlación en el tiempo (de pulso a pulso), que difiere de la del ruido del receptor, estadísticamente independiente entre pulsos [L-65] y [L-66].

=== Modelos de Swerling

Swerling propuso cuatro modelos estadísticos, y para cada uno calculó la relación señal/ruido necesaria en función de $P_d$, $P_"fa"$ y el número de pulsos integrados [L-66]. Se resumen en la @tab-swerling, y en todos los casos la sección que se sustituye en la ecuación del radar es el valor medio $sigma_"av"$.

#figure(
  table(
    columns: 4,
    table.header[Caso][Fluctuación][Correlación][pdf de $sigma$],
    [1], [de barrido a barrido (lenta)], [pulsos de un barrido, constantes; independientes entre barridos], [exponencial, @eq-sw1],
    [2], [de pulso a pulso (rápida)], [independientes entre pulsos], [exponencial, @eq-sw1],
    [3], [de barrido a barrido], [constante en un barrido; independiente entre barridos], [@eq-sw3],
    [4], [de pulso a pulso], [independientes entre pulsos], [@eq-sw3],
  ),
  caption: [Modelos de fluctuación de Swerling, según [L-66].],
) <tab-swerling>
// Esta tabla resume el texto de [L-66]

Los casos 1 y 2 usan la pdf

$ p(sigma) = 1 / sigma_"av" exp( - sigma / sigma_"av" ), quad sigma >= 0, $ <eq-sw1>
// Esta expresión se encuentra en [L-66] (Ec. 2.40)

que corresponde a un blanco con muchos dispersores independientes de áreas comparables, sin ninguno dominante. Con unos cuatro o cinco dispersores ya es una buena aproximación en muchos casos [L-66]. Se llama a veces blanco de Rayleigh, aunque la @eq-sw1 es la exponencial (@eq-exponencial) y no la de Rayleigh (@eq-rayleigh): la exponencial describe el cuadrado de una tensión de Rayleigh. Los casos 3 y 4 usan

$ p(sigma) = (4 sigma) / sigma_"av"^2 exp( - (2 sigma) / sigma_"av" ), quad sigma >= 0, $ <eq-sw3>
// Esta expresión se encuentra en [L-66] (Ec. 2.41)

que representa un blanco con un dispersor grande más varios pequeños [L-66].

En general, un blanco fluctuante exige mayor relación señal/ruido que uno constante (caso 0, sin fluctuación). Por ejemplo, para $n = 10$ pulsos integrados, $n_f = 10^8$ y $P_d = 0.95$, la Fig. 2.22 da 6.2 dB por pulso en el caso 0 y 16.8 dB en el caso 1. Un radar diseñado con una sección constante $sigma_"av"$ que en realidad fluctuara como el caso 1 vería reducido su alcance en un factor 1.84, resultado de los 10.6 dB de diferencia y de la dependencia $R_"max" prop (S\/N)^(-1\/4)$ de la @eq-radar-sn: $10^(10.6 \/ 40) approx 1.84$ [L-67]. El caso 1 es el más exigente. Para $P_d$ mayor que unos 0.3 (siempre en la práctica), las fluctuaciones de barrido a barrido (casos 1 y 3) exigen más relación señal/ruido que las de pulso a pulso (casos 2 y 4), que tienden a promediarse hacia el caso 0 al integrar más pulsos independientes [L-67].

=== Pérdida por fluctuación

Para los casos 1 y 3 con un único pulso, la relación necesaria se obtiene sumando (en dB) a la de la Fig. 2.6 el valor de la Fig. 2.23, llamado *pérdida por fluctuación* $L_f$ [L-67] y [L-68]. Con fluctuación de barrido a barrido la mejora de integración $n E_i (n)$ es la misma que para sección constante, y se sustituye $(S\/N)_1$ por $(S\/N)_1 L_f$ en la ecuación del radar. Por ser el más conservador, el caso 1 es el que más se usa. Cuando el número de pulsos integrados es mayor que unos 10 a 20, los casos 2 y 4 se aproximan al 0 y no hace falta tratarlos aparte [L-68].

Los casos de Swerling suponen pulsos totalmente correlados ($rho = 1$) o totalmente incorrelados ($rho = 0$). Para correlaciones intermedias, Barton propone una pérdida aproximada con $n_e$ muestras independientes:

$ L_f (n_e) = (L_f)^(1 \/ n_e), $ <eq-lf-ne>
// Esta expresión se encuentra en [L-68] (Ec. 2.42); en dB, $L_f (n_e)_"dB" = L_f (1)_"dB" \/ n_e$ [L-69]

donde $L_f$ es la de la Fig. 2.23 para un pulso. El número de muestras independientes integradas en el tiempo de observación $t_0$ es el menor entre $n$ y $n_e$, con

$ n_e = 1 + t_0 / t_c <= n, $ <eq-ne-tc>
// Esta expresión se encuentra en [L-69] (Ec. 2.43)

y $t_c$ el *tiempo de correlación* del eco (inverso del ancho de banda efectivo de ruido del espectro bilateral de las fluctuaciones, o tiempo que tarda la sección en tomar un valor nuevo; es difícil de especificar y depende del escenario). Kanter lo expresa en función del coeficiente de correlación:

$ n_e = 1 + (n - 1) ln(1 / rho) <= n. $ <eq-ne-rho>
// Esta expresión se encuentra en [L-69] (Ec. 2.44)

La ecuación del radar para estos casos es

$ R_"max"^4 = (P_t G A_e sigma n E_i (n)) / ((4 pi)^2 k T_0 B F_n (S\/N)_1 (L_f)^(1 \/ n_e)), $ <eq-radar-swerling>
// Esta expresión se encuentra en [L-69] (Ec. 2.45)

con $(S\/N)_1$ de la Fig. 2.6, $n E_i (n)$ de la Fig. 2.7 y $L_f$ de la curva "casos 1 y 2" o "casos 3 y 4" de la Fig. 2.23, según la pdf. Se recuperan los casos así: caso 1, $rho = 1$ y $n_e = 1$ (curva 1 y 2); caso 2, $rho = 0$ y $n_e = n$ (curva 1 y 2; si $n > 20$ y $P_d <= 0.9$, equivale al caso 0); caso 3, $rho = 1$ y $n_e = 1$ (curva 3 y 4); caso 4, $rho = 0$ y $n_e = n$ (curva 3 y 4; si $n > 10$ y $P_d <= 0.9$, equivale al caso 0); caso 0, $L_f = 1$ [L-69] y [L-70].

=== Decorrelación en frecuencia

Un blanco complejo también decorrela su eco al cambiar la frecuencia con el aspecto fijo. Si se modela con dos dispersores separados una distancia radial $D$, la diferencia de fase de sus ecos es $4 pi (f \/ c) D$, y un cambio de frecuencia $Delta f$ la cambia en $Delta phi = 4 pi (Delta f \/ c) D$. Si ese cambio supera $2 pi$, la señal se considera independiente de la anterior, de modo que

$ Delta f = c / (2 D) $ <eq-decorrelacion>
// Esta expresión no está numerada; se encuentra en [L-70]

decorrela el eco (aquí $D$ es una dimensión radial característica del blanco, no necesariamente su longitud física proyectada) [L-70]. Hay dos formas de aprovecharlo:

- La *diversidad en frecuencia* usa varios transmisores en paralelo, cada uno a una frecuencia distinta. Los radares de control de tráfico aéreo suelen tener dos transmisores, por redundancia, y los hacen funcionar a frecuencias distintas para obtener dos ecos independientes. La mejora se lee de la Fig. 2.23: con caso 1 y $P_d = 0.8$ la pérdida por fluctuación es 5.4 dB, que con dos frecuencias se reduce a la mitad, 2.7 dB de ganancia (además de los 3 dB del segundo transmisor). La ganancia depende de $P_d$: 4 dB con $P_d = 0.9$, solo 0.8 dB con $P_d = 0.5$ y 8.6 dB con $P_d = 0.99$. Con tres y cuatro transmisores la mejora es 3.6 y 4.1 dB (con 5.4 dB de pérdida), por lo que rara vez compensa pasar de dos [L-70] y [L-71].
- La *agilidad en frecuencia* cambia la frecuencia de pulso a pulso, y decorrela el eco si el cambio supera $c \/ 2D$. Dentro de un ancho de banda total $B$ hay unas $n_e = 1 + B \/ (c \/ 2D)$ muestras independientes, que pueden lograrse con un único transmisor de banda ancha. Sirve también contra interferencias de banda estrecha, pero no es compatible con el procesado Doppler (capítulo 3), que necesita varios pulsos a la misma frecuencia, mientras que la diversidad sí lo es [L-71].
// El número de muestras independientes se encuentra en [L-71] (Ec. 2.46)

=== Otros modelos estadísticos

Las pdf de los casos de Swerling son casos particulares de la pdf *chi cuadrado de grado $2m$*, también llamada gamma:

$ p(sigma) = m / (Gamma(m) sigma_"av") ( (m sigma) / sigma_"av" )^(m - 1) exp( - (m sigma) / sigma_"av" ), quad sigma >= 0, $ <eq-chi2>
// Esta expresión se encuentra en [L-71] (Ec. 2.47); el libro la escribe con $(m - 1)!$, que coincide con $Gamma(m)$ para $m$ entero

donde $2m$ puede ser cualquier real positivo. El caso $m = 1$ es la exponencial (casos 1 y 2) y $m = 2$ equivale a los casos 3 y 4. El cociente entre desviación típica y media es $m^(-1\/2)$, de modo que cuanto mayor es $m$, menos fluctúa el blanco y el límite $m -> oo$ es el blanco no fluctuante. Un $m$ entre 0.3 y 2 ajusta la estadística de formas simples como cilindros [L-71].

Otros modelos son la pdf de Rice, adecuada para un dispersor dominante más muchos pequeños (parecida a la de Swerling 3 y 4, pero no igual), y la logarítmico-normal, que no deriva de un modelo teórico pero ajusta algunos satélites, barcos, cilindros y placas y tiene "colas altas" (mayor probabilidad de valores anormalmente grandes). Hay muchos más, y para la mayoría la única justificación es que ajustan datos experimentales [L-71] y [L-72].

=== Qué modelo usar

Pocos blancos reales encajan con precisión en un modelo. Medidas en aviones indican que el modelo de Rayleigh ($m = 1$) suele ajustar mejor que otros, pero el parámetro $m$ medido llegó a variar entre 0.5 y casi 20 según el aspecto, y a veces ningún $m$ ajustaba [L-72]. Además hay que decidir qué $sigma_"av"$ sustituir: un promedio sobre los $4 pi$ estereorradianes lo dominan los aspectos de costado, de arriba y de abajo, poco habituales, y el promedio debe ser el de los *valores numéricos*, no el de los valores en dB [L-73]. El libro enumera tres enfoques [L-73]:

+ Emplear la mejor suposición de modelo estadístico, basada en la experiencia.
+ Usar sección constante con un valor superado la mayor parte del tiempo (90 o 95 % o más). Es el más sencillo y el que prefiere el autor.
+ Usar el caso 1 de Swerling, conservador y el más empleado en especificaciones de contratación. Es buena opción con $P_d >= 0.9$.

Con $P_d = 0.5$ hay poca diferencia entre los modelos, así que no tiene sentido emplear uno sofisticado. Los fabricantes tienden a dar el alcance con $P_d = 0.5$, mientras que los compradores quieren $P_d$ de 0.9 o más, valor que el autor prefiere [L-73].

== Potencia del transmisor

La potencia $P_t$ de la ecuación del radar es la potencia de pico del pulso, que no es el valor instantáneo máximo de una sinusoide sino la mitad de este [L-73]. Más importante como medida de rendimiento es la *potencia media* $P_"av"$. Para un tren de pulsos rectangulares de anchura $tau$ y periodo $T_p = 1 \/ f_p$,

$ P_"av" = (P_t tau) / T_p = P_t tau f_p. $ <eq-pav>
// Esta expresión se encuentra en [L-74] (Ec. 2.50)

El *ciclo de trabajo* (o factor de trabajo) es $P_"av" \/ P_t = tau \/ T_p = tau f_p$. Los radares de pulsos suelen tener ciclos de trabajo de 0.001 a 0.5, aproximadamente, y un radar CW tiene ciclo unidad. Depende de la forma de onda, la anchura de pulso, el uso de compresión de pulsos, las ambigüedades en distancia y Doppler y el tipo de transmisor [L-74].

Sustituir $P_t = P_"av" \/ (tau f_p)$ de la @eq-pav en la @eq-radar-swerling (con $L_f = 1$) da la ecuación en función de la potencia media:

$ R_"max"^4 = (P_"av" G A_e sigma n E_i (n)) / ((4 pi)^2 k T_0 F_n (B tau) (S\/N)_1 f_p). $ <eq-radar-pav>
// Esta expresión se encuentra en [L-74] (Ec. 2.51)

Se agrupan $B$ y $tau$ porque su producto es aproximadamente 1 en un radar bien diseñado. Como la energía de un pulso es $E_p = P_t tau = P_"av" \/ f_p$, la ecuación en función de la energía es

$ R_"max"^4 = (E_p G A_e sigma n E_i (n)) / ((4 pi)^2 k T_0 F_n (B tau) (S\/N)_1) = (E_T G A_e sigma E_i (n)) / ((4 pi)^2 k T_0 F_n (B tau) (S\/N)_1), $ <eq-radar-energia>
// Esta expresión se encuentra en [L-74] (Ec. 2.52); $E_T = n E_p$ es la energía total de los $n$ pulsos

donde la segunda igualdad se obtiene de $E_T = n E_p$.

== Frecuencia de repetición de pulsos

=== Elección de la PRF y ecos de varias vueltas

La PRF suele fijarla el alcance máximo no ambiguo del capítulo 1: $f_p = c \/ (2 R_"un")$. A veces aparecen ecos más allá de $R_"un"$, por un blanco o fuente de clutter excepcionalmente grandes (una montaña) o por propagación anómala que extiende el alcance más allá del horizonte. Los que llegan después del periodo de repetición son ecos de *segunda vuelta*, o de *varias vueltas* si vienen de más allá de $2 R_"un"$, y su distancia aparente da error y confusión. Además, el clutter de distancias mayores que $R_"un"$ puede enmascarar ecos no ambiguos a distancias menores [L-74] y [L-75]. Algunos radares, como los Doppler de pulsos, trabajan siempre con una PRF que da ambigüedades en distancia, para disfrutar de las ventajas de una PRF alta; resolverlas es parte esencial de su operación (Sec. 3.9) [L-75].

=== Reconocer y resolver las ambigüedades

Con PRF constante, los ecos de varias vueltas no se reconocen: sobre un A-scope o un PPI, los de distancia ambigua (B y C de la Fig. 2.24) son indistinguibles del no ambiguo (A), y solo la distancia de A es correcta [L-75]. Se reconocen cambiando la PRF: el eco no ambiguo permanece en su distancia verdadera, y los ambiguos cambian de distancia aparente con cada PRF [L-75] y [L-76].

Sea $R_1$ la distancia aparente medida con la PRF $f_(p 1)$, de alcance no ambiguo $R_("un" 1)$. La distancia verdadera es uno de los valores del conjunto $\{ R_1, R_1 + R_("un" 1), R_1 + 2 R_("un" 1), ... \}$. Con una segunda PRF $f_(p 2)$ y distancia aparente $R_2$, pertenece a $\{ R_2, R_2 + R_("un" 2), R_2 + 2 R_("un" 2), ... \}$. La distancia correcta es el valor común a ambos conjuntos. En teoría bastan dos PRF, pero en la práctica se emplean a menudo tres, para mayor exactitud y para evitar valores falsos. La PRF puede cambiarse de pulso a pulso, cada medio ancho de haz o en cada giro de la antena, con ventajas y limitaciones en cada caso [L-76].
// El procedimiento se encuentra en [L-76]

== Parámetros de la antena

=== Ganancia, área efectiva y ancho de haz

La antena coloca la energía sobre el blanco, recoge el eco y determina su posición angular. Hay siempre un compromiso entre el tamaño de la antena y el del transmisor: si una es pequeña, el otro tiene que ser grande, por lo que suelen preferirse antenas grandes si no lo impiden limitaciones prácticas [L-76]. La *ganancia de potencia* en una dirección $(theta, phi)$ es

$ G(theta, phi) = ("potencia radiada por unidad de ángulo sólido en" (theta, phi)) / ("potencia aceptada de la fuente" \/ 4 pi). $ <eq-ganancia-def>
// Esta expresión se encuentra en [L-76] (Ec. 2.53)

Si es mayor que la unidad en unas direcciones, debe ser menor en otras. La ganancia *directiva* sustituye el denominador por la potencia radiada por la antena entre $4 pi$; la diferencia es que la de potencia incluye las pérdidas de la antena. En la ecuación del radar interesa la ganancia de potencia máxima, que en la práctica apenas difiere de la directiva salvo en las agrupaciones en fase, y se trata aquí como igual [L-76] y [L-77].

Para una antena sin pérdidas, la ganancia se relaciona con el área efectiva por la misma expresión del capítulo 1:

$ G = (4 pi A_e) / lambda^2 = (4 pi rho_a A) / lambda^2, $ <eq-ganancia-ae>
// Esta expresión se encuentra en [L-77] (Ec. 2.54)

y, aproximadamente, con los anchos de haz de media potencia en acimut $theta_a$ y en elevación $theta_e$ (en grados):

$ G approx 26000 / (theta_a theta_e), $ <eq-ganancia-haz>
// Esta expresión se encuentra en [L-77] (Ec. 2.55)

que da 44 dB para un haz de lápiz de 1° ($10 log_10 26000 = 44.1 "dB"$ por comprobación propia). Cuando no hay más información, el ancho de haz depende de la dimensión $D$ de la antena (en el plano en que se mide, con las mismas unidades que $lambda$) como

$ theta_3 approx 65 lambda / D "grados", $ <eq-ancho-haz-2>
// Esta expresión se encuentra en [L-77] (Ec. 2.56); es la misma estimación del capítulo 1

que puede aplicarse a una antena con un nivel de lóbulos laterales de pico de 25 a 28 dB [L-77]. El ancho de haz se mide con bastante exactitud, pero la ganancia "es una de las medidas menos precisas" de un sistema de antena, y rara vez se justifica dar más de un decimal en dB [L-77].

=== Tiempo de revisita y forma del haz

El *tiempo de revisita* (o de barrido) es el que tarda la antena en volver a mirar la misma región, y es inversamente proporcional a las rpm de una antena giratoria. Es un compromiso entre reunir suficiente energía para blancos débiles y re-medir rápido la posición de blancos móviles. Valores típicos: 10 a 12 s (6 a 5 rpm) en control de tráfico aéreo civil de largo alcance, unos 4 s (15 rpm) en radares militares de largo alcance, 1 o 2 s (60 o 30 rpm) en los militares de corto alcance contra blancos rasantes de alta velocidad, unos 3 s (20 rpm) en radares marinos pequeños y 60 rpm en los de vigilancia de superficie en aeropuertos [L-77] y [L-78].

Los radares usan haces de *lápiz* (anchos casi iguales en horizontal y vertical, del orden de un grado, para medida precisa en acimut y elevación: seguimiento, radares 3-D y muchos de agrupación en fase) o de *abanico* (un ángulo mucho menor que el otro; en vigilancia 2-D, un acimut de uno o pocos grados y una elevación de cuatro a diez veces mayor, sin medida de elevación). Para cubrir un gran volumen con haces de lápiz se emplean varios haces barridos (de 3 a 9) o *haces apilados* (de 6 a 16 haces fijos contiguos) en los radares 3-D. Con abanico se suele modificar la forma, como en el haz cosecante cuadrado (Fig. 2.25) [L-78] y [L-79].

=== Patrón cosecante cuadrado

Un abanico simple no cubre bien blancos altos y cercanos, y radiaría más energía de la necesaria a elevaciones altas, donde los aviones no están lejos. Se corrige haciendo que la ganancia en elevación sea proporcional al cuadrado de la cosecante del ángulo:

$ G(phi) = G(phi_0) (csc^2 (phi)) / (csc^2 (phi_0)), quad phi_0 <= phi <= phi_m, $ <eq-csc2>
// Esta expresión se encuentra en [L-79] (Ec. 2.57)

con $phi_0$ y $phi_m$ los límites angulares entre los que el haz sigue esa forma. El máximo del haz se sitúa en $phi_0 \/ 2$ cuando el límite inferior de media potencia apunta al horizonte, y $phi_0$ se fija con el alcance y la altura máximos del blanco (con Tierra plana). Con Tierra curva es más complicado. La forma cuesta hasta 3 dB de ganancia o área efectiva (Sec. 9.7) [L-79].

La propiedad que justifica esta forma es que, para un blanco de sección constante a altura constante $h$, la potencia recibida no depende de la distancia. Con Tierra plana y sin multitrayecto, se parte de la ecuación del capítulo 1 en función de $G$ ($P_r = P_t G^2 lambda^2 sigma \/ ((4 pi)^3 R^4)$, por $A_e = G lambda^2 \/ 4 pi$) y se usa $csc(phi) = R \/ h$, o sea $R = h csc(phi)$ (@eq-csc2 aplicada a $G$):

$ P_r &= (P_t lambda^2 sigma) / ((4 pi)^3) dot G^2 (phi_0) / (csc^4 (phi_0)) dot (csc^4 (phi)) / (R^4) \
  &= K_1 (csc^4 (phi)) / (h^4 csc^4 (phi)) = K_1 / h^4, $ <eq-csc2-pr>
// Esta expresión se encuentra en [L-80] (Ec. 2.58); el paso $R^4 = h^4 csc^4 (phi)$ es de comprobación propia

con $K_1$ constante. La potencia recibida es independiente de $R$ [L-79] y [L-80]. La mayoría de los radares de vigilancia aérea 2-D de superficie usan algún haz con forma, y algunos radares aerotransportados de vigilancia del suelo lo emplean invertido [L-79].

== Pérdidas del sistema

=== Idea general

Las pérdidas del sistema $L_s$ son las no recogidas en otras partes de la ecuación. Se incluyen en el denominador como un número mayor que la unidad, inverso de un rendimiento menor que la unidad. Aunque cada pérdida individual sea pequeña, muchas juntas son notables: lo habitual es entre 10 dB y más de 20 dB, y una pérdida de 12 dB reduce el alcance a la mitad [L-80]. La relación sale de $R_"max" prop L_s^(-1\/4)$, que con 12 dB da $10^(-12 \/ 40) = 0.50$ (comprobación propia). Todos los valores numéricos de esta sección son ilustrativos [L-80]. Las pérdidas por integración y por fluctuación ya se han visto, y la propagación en la atmósfera se trata en el capítulo 8 [L-80].

=== Pérdidas de las líneas y componentes de microondas

Hay pérdidas en la línea de transmisión entre antena y transmisor/receptor y en componentes como el duplexor, el protector del receptor, la junta rotatoria, los acopladores direccionales, los conectores, las curvas y la desadaptación en la antena [L-80]. Como la misma línea sirve en transmisión y recepción, la pérdida a insertar es el *doble* de la unidireccional (la Tabla 2.2 da valores en dB por 100 pies para guías de onda normalizadas). A frecuencias bajas la línea introduce poca pérdida salvo longitudes enormes, y a las altas puede ser apreciable, por lo que conviene acercar transmisor y receptor a la antena [L-80] y [L-81]. Un conector mal apretado puede restar un alcance apreciable, como ilustra la anécdota de pie de página del libro [L-81].

#figure(
  table(
    columns: 2,
    table.header[Componente (radar en banda S, 3 GHz)][Pérdida bidireccional (dB)],
    [100 pies de guía de onda de aluminio], [1.0],
    [Duplexor y dispositivos asociados], [2.0],
    [Junta rotatoria], [0.8],
    [Conectores y curvas (estimación)], [0.3],
    [Otros dispositivos de RF], [0.4],
    [*Total de ejemplo*], [*4.5*],
  ),
  caption: [Ejemplo ilustrativo de pérdidas de las líneas y componentes de microondas, de [L-82]. La suma es de comprobación propia: $1.0 + 2.0 + 0.8 + 0.3 + 0.4 = 4.5$.],
) <tab-plumbing>
// Esta tabla se encuentra en [L-82]

=== Pérdidas por forma del haz y por barrido

La ecuación toma la ganancia constante e igual a su máximo, pero la antena que explora modula en amplitud el tren de pulsos devuelto por el blanco: solo uno de los $n$ pulsos recibe la ganancia máxima $G$ (Fig. 2.26). El libro opta por suponer un tren de amplitud constante, con la ganancia máxima, y añadir una *pérdida por forma del haz*, método más sencillo y menos exacto, que se calcula comparando la energía total recibida con la que daría un tren constante, y no depende de $P_d$. Se aproxima el patrón de potencia unidireccional por una gaussiana, $exp(-2.78 theta^2 \/ theta_B^2)$, con $theta$ medido desde el centro del haz y $theta_B$ el ancho de media potencia. Con $n_B$ pulsos dentro del ancho de media potencia y $n$ pulsos integrados (impar, con el central en el máximo del haz), la pérdida es

$ L_"haz" = n / (1 + 2 sum_(k=1)^((n-1) \/ 2) exp( - (5.55 k^2) / (n_B - 1)^2 )). $ <eq-forma-haz>
// Esta expresión se encuentra en [L-83] (Ec. 2.59)

Por ejemplo, con $n = n_B = 11$ la pérdida es de unos 2 dB (comprobación propia: la suma vale 3.02 y $11 \/ 7.03 = 1.57 approx 1.9 "dB"$). Vale para un haz de abanico y para un haz de lápiz si el blanco pasa por el centro; si no, la pérdida aumenta por el cuadrado del cociente de ganancias máximas, por el recorrido de ida y vuelta [L-82] y [L-83]. Con muchos pulsos integrados, Blake obtuvo 1.6 dB para un abanico que barre en una coordenada y 3.2 dB para un lápiz que barre en dos, valores que suelen usarse salvo si hay pocos pulsos. Una pérdida similar ocurre al explorar un volumen con haz de lápiz de paso a paso (agrupaciones en fase) o en algunos radares de seguimiento por exploración cónica [L-83].

Cuando la antena gira tan deprisa respecto del tiempo de ida y vuelta que la ganancia hacia el blanco en transmisión no es la de recepción, hay una *pérdida por barrido* (_scanning loss_), relevante en radares de vigilancia espacial o defensa antimisil y no en la mayoría de los de vigilancia aérea [L-83].

=== Otras pérdidas

- *Radomo:* unos 1.2 dB bidireccionales para un radomo metálico de estructura espacial en tierra, de L a X [L-83] y [L-84].
- *Agrupaciones en fase:* pérdidas de la red de distribución, que debería incluirse en la ganancia de antena pero rara vez se hace [L-84].
- *Filtro no adaptado:* de 0.5 a 1.0 dB (y similar con compresión de pulsos) [L-84].
- *CFAR:* más de 2.0 dB según el tipo (Sec. 5.7) [L-84].
- *Integradores automáticos:* de 1.5 a 2.0 dB para el detector de ventana móvil binario (Sec. 5.6) [L-84].
- *Nivel del umbral:* una fracción de dB, por el margen de seguridad con que se fija por la sensibilidad exponencial del tiempo de falsa alarma [L-84].
- *Limitación:* un limitador duro ideal reduce la relación señal/ruido de una sinusoide en ruido gaussiano en un factor $pi \/ 4$ para señal pequeña, es decir, en 1 dB ($10 log_10 (pi \/ 4) = -1.05 "dB"$, comprobación propia). Se usaba en radares MTI antiguos, y hoy se evita porque limita la atenuación de clutter [L-84].
- *Pérdida por solape (_straddling_):* con puertas de distancia no centradas en el pulso o más anchas de lo óptimo, y de filtro en bancos Doppler, si la línea espectral no está centrada [L-84] y [L-85].
- *Pérdida por muestreo:* con una muestra por anchura de pulso, unos 2 dB (para $P_d = 0.90$ y $P_"fa" = 10^(-6)$), con dos, unos 0.5 dB y con tres, menos de 0.2 dB [L-85].
- *Procesado Doppler:* múltiples formas de onda redundantes para resolver ambigüedades o evitar velocidades ciegas (por ejemplo, ocho PRF para tener al menos tres periodos de integración, con una pérdida de $8 \/ 3$, o 4.3 dB), pérdidas por eclipsado, forma de los filtros Doppler y pulsos de relleno. Por eso suele desconectarse el MTI más allá de donde se espera clutter [L-85] y [L-86].
- *Pérdida por colapso:* aparece al integrar muestras de solo ruido junto con las de señal más ruido, por ejemplo al superponer en un PPI las salidas de $N$ haces apilados de un radar 3-D, o al mostrar un radar de alta resolución en una pantalla de resolución menor. Marcum mostró que integrar $m$ pulsos de ruido con $n$ de señal más ruido equivale a integrar $m + n$ pulsos de relación $n (S\/N)_1 \/ (m + n)$, así que

  $ L_c (m, n) = (L_i (m + n)) / (L_i (n)). $ <eq-colapso>
  // Esta expresión se encuentra en [L-86] (Ec. 2.60)

  Con 10 pulsos de señal más ruido y 30 de solo ruido, $L_i (40) = 3.5 "dB"$ y $L_i (10) = 1.7 "dB"$, y la pérdida por colapso es de $3.5 - 1.7 = 1.8 "dB"$ (las pérdidas en dB se restan al ser un cociente). Un detector lineal puede dar un colapso mayor con pocos pulsos y gran razón de colapso. Con detección automática por umbral no hace falta incurrir en ella [L-86].
- *Operador:* si es atento y está entrenado, rinde como la teoría de detección electrónica, y se descarta como pérdida (conviene relevarlo cada 20 a 30 min) [L-86] y [L-87].
- *Degradación del equipo:* al operar en campo, de 1 a 3 dB si no hay otro dato [L-87].

=== Propagación y pérdidas "del vendedor y del comprador"

Los efectos de propagación no son pérdidas del sistema: pueden aumentar o disminuir el alcance respecto del espacio libre, y se incluyen con un *factor de propagación* $F^4$ (sobre todo por el lobulado del patrón de elevación debido a la reflexión en la superficie, Sec. 8.2) y un *factor de atenuación* $exp(-2 alpha R)$, con $alpha$ el coeficiente de atenuación en #term("neper")[Unidad adimensional de atenuación en amplitud: el número de nepers es $ln(A_2 \/ A_1)$. Un neper equivale a 8.686 dB; el libro [L-87] escribe esta equivalencia al revés ("un decibelio equivale a 8.686 nepers"), lo que es un error de redacción.] por unidad de distancia. Ambos factores van en el numerador de la ecuación [L-87]. Otros efectos son la refracción, que suele aumentar el alcance, los conductos atmosféricos, que lo aumentan a baja altitud, y la atenuación en aire claro o en precipitación, normalmente despreciable [L-87].

No existe un procedimiento acordado para determinar las pérdidas del sistema, y el vendedor de un radar tiende a ser más optimista que el comprador. No se puede verificar ni comparar el rendimiento anunciado sin conocer las pérdidas que incluyó cada fabricante [L-87].

== Otras consideraciones sobre la ecuación del radar

=== La ecuación completa

La forma simple, con las modificaciones vistas, queda así:

$ R_"max"^4 = (P_"av" G A rho_a sigma n E_i (n) F^4 exp(-2 alpha R_"max")) / ((4 pi)^2 k T_0 F_n (B tau) f_p (S\/N)_1 L_f L_s). $ <eq-radar-completa>
// Esta expresión se encuentra en [L-88] (Ec. 2.61)

Los símbolos son los siguientes: $R_"max"$ (m), $P_"av"$ (W), $G$ (ganancia de la antena), $A$ (área de la antena, $"m"^2$), $rho_a$ (eficiencia de apertura), $sigma$ ($"m"^2$), $n$ (pulsos integrados), $E_i (n)$ (eficiencia de integración), $F^4$ (factor de propagación), $alpha$ (coeficiente de atenuación, nepers por unidad de distancia), $k = 1.38 dot 10^(-23) "J/K"$, $T_0 = 290 "K"$, $F_n$ (figura de ruido), $B$ (ancho de banda, Hz), $tau$ (anchura de pulso, s), $f_p$ (PRF, Hz), $(S\/N)_1$ (relación señal/ruido necesaria como si la detección se basara en un solo pulso), $L_f$ (pérdida por fluctuación) y $L_s$ (pérdida del sistema) [L-88]. Nótese que $A_e = rho_a A$, de modo que $G A rho_a = G A_e$ y la @eq-radar-completa generaliza la @eq-radar-swerling y la @eq-radar-pav.

El alcance aparece en ambos miembros (por la atenuación), así que la @eq-radar-completa es una ecuación en $R_"max"$ que se resuelve para $R_"max"$ de forma numérica o iterativa, no por despeje directo. Se omite el factor de atenuación cuando es despreciable. El producto $k T_0$ vale $4 dot 10^(-21) "W/Hz"$ y en casi todos los diseños $B tau approx 1$. Para un pulso rectangular, la relación señal/ruido puede expresarse como cociente de energías, $S \/ N = (E \/ tau) \/ (N_0 B) = E \/ (N_0 B tau)$, con $E$ la energía del pulso recibido y $N_0$ la potencia de ruido por unidad de ancho de banda. Por tanto, si $B tau = 1$, entonces $(S\/N)_1 = (E \/ N_0)_1$. Omitiendo propagación, atenuación y fluctuación, resulta

$ R_"max"^4 = (E_T G A rho_a sigma E_i (n)) / ((4 pi)^2 k T_0 F_n (E \/ N_0)_1), $ <eq-radar-e-n0>
// Esta expresión se encuentra en [L-88] (Ec. 2.62)

válida para cualquier forma de onda, no solo para el pulso rectangular, siempre que haya un filtro adaptado en recepción y se definan bien las energías [L-88] y [L-89]. La @eq-radar-completa puede modificarse para CW, FM-CW, Doppler de pulsos y MTI, y adaptarse a aplicaciones especiales como la ecuación de vigilancia que sigue. Radares de seguimiento, de apertura sintética o transhorizonte requieren más cambios. Si el clutter limita el rendimiento, la ecuación es completamente distinta (capítulo 7), y con interferencia de ruido hostil el ruido del receptor se sustituye por el de la interferencia [L-89].

=== Ecuación del radar de vigilancia

Un radar de vigilancia debe explorar una región angular $Omega$ (en estereorradianes) en un tiempo de revisita $t_s$ (en segundos). El ángulo sólido total alrededor de un punto es $4 pi$ estereorradianes (una región de 360° en acimut y 30° en elevación vale $2 pi sin(30°) = pi$). El tiempo de revisita es $t_s = t_0 Omega \/ Omega_0$, con $t_0 = n \/ f_p$ el tiempo que el haz permanece sobre el blanco y $Omega_0 approx theta_a theta_e$ (en radianes) el ángulo sólido del haz, y la ganancia es aproximadamente $G = 4 pi \/ Omega_0$. Sustituir esto en la @eq-radar-completa simplificada (sin $F$, atenuación ni $L_f$, con $B tau = 1$ y $A_e = rho_a A$) da la ecuación de vigilancia:

$ R_"max"^4 = (P_"av" A_e sigma E_i (n)) / (4 pi k T_0 F_n (S\/N)_1 L_s) dot t_s / Omega. $ <eq-vigilancia>
// Esta expresión se encuentra en [L-89] (Ec. 2.63)

La deducción detallada es esta (comprobación propia):

$ R_"max"^4 &= (P_"av" G A_e sigma n E_i (n)) / ((4 pi)^2 k T_0 F_n (S\/N)_1 L_s f_p) \
  &= (P_"av" (4 pi \/ Omega_0) A_e sigma E_i (n)) / ((4 pi)^2 k T_0 F_n (S\/N)_1 L_s) dot (n / f_p) \
  &= (P_"av" A_e sigma E_i (n)) / (4 pi k T_0 F_n (S\/N)_1 L_s) dot (t_s Omega_0) / (Omega_0 Omega). $

donde en el último paso se usa $n \/ f_p = t_0 = t_s Omega_0 \/ Omega$, y el $Omega_0$ del numerador (de $n \/ f_p$) se cancela con el del denominador (de $G$). La ecuación muestra que los parámetros bajo control del diseñador son la potencia media y la apertura efectiva, y de ahí la importancia del *producto potencia-apertura* como medida de la capacidad de vigilancia de largo alcance. La frecuencia no figura explícitamente, aunque en la práctica es más fácil lograr potencia alta y antenas grandes a frecuencias bajas, y el tiempo adverso influye menos en ellas. No es una buena base para diseñar, porque no muestra muchos factores, y es mejor usar la @eq-radar-completa con las ecuaciones auxiliares, como la @eq-hits. Tampoco contiene explícitamente el número de pulsos por dwell, y si hay pocos, la pérdida por forma del haz es grande. Con MTI o Doppler de pulsos, más tiempo sobre el blanco significa más pulsos procesados y mayor reducción de clutter, por lo que puede hacer falta una modificación si el procesado Doppler exige un tiempo fijo o un mínimo de pulsos [L-89] y [L-90].

=== Criterio M de N y probabilidad acumulada

Hasta aquí la probabilidad de detección se refería a un solo barrido. Un radar de vigilancia rara vez decide con una sola observación. Un criterio habitual es exigir $M$ detecciones en $N$ barridos, con $1 <= M <= N$ (por ejemplo, 2 de 2, 2 de 3, 3 de 4 o 3 de 5). Si $P$ es la probabilidad de detección en un solo ensayo (barrido), la de $M$ detecciones en $N$ es la probabilidad binomial

$ P_(M"/"N) = sum_(k=M)^N binom(N, k) P^k (1 - P)^(N - k). $ <eq-m-de-n>
// Esta expresión se encuentra en [L-90] (Ec. 2.64); el libro la escribe con $N! \/ (k! (N - k)!)$

Para $M = 2$ y $N = 3$, resulta $3 P^2 - 2 P^3$ (el libro da este resultado; se comprueba desarrollando $binom(3, 2) P^2 (1 - P) + P^3$), y es mayor que $P$ si y solo si $P > 1 \/ 2$ (comprobación propia: $3 P^2 - 2 P^3 - P = P (2 P - 1)(1 - P)$). La misma fórmula sirve para la falsa alarma, y con este criterio la probabilidad de un informe falso es mucho menor que la de un barrido, por lo que puede tolerarse una $P_"fa"$ por barrido mayor y bajar el umbral, con el consiguiente ahorro de potencia. Ejemplos del libro con $2 "de" 3$: con $P_"fa" = 10^(-5)$ por barrido, la probabilidad de informe falso es $3 dot 10^(-10)$, y para que sea $10^(-8)$ basta $P_"fa" = 0.6 dot 10^(-4)$ por barrido [L-90].

Muchos radares modernos declaran un blanco al *establecer una pista* y no por una sola detección (Sec. 4.9), por ejemplo con 3 de 5 barridos más la restricción de que la pista tenga una velocidad esperada y no cambie de rumbo de forma inusual. Como es muy improbable que el ruido establezca una pista lógica, se tolera una $P_"fa"$ por cruce de umbral relativamente alta [L-90] y [L-91].

La *probabilidad acumulada de detección* es la de detectar el blanco al menos una vez en $N$ barridos:

$ P_c = 1 - (1 - P_d)^N, $ <eq-acumulada>
// Esta expresión se encuentra en [L-91] (Ec. 2.65)

con $P_d$ la probabilidad por barrido, suponiendo que el alcance no cambia de forma apreciable durante los $N$ barridos. Puede ser grande aunque $P_d$ sea pequeña, pero no es buena medida de rendimiento, pues rara vez se decide con una sola detección [L-91]. Se ha dicho que el alcance según la probabilidad acumulada varía con la tercera potencia y no con la cuarta (potencia) [L-91].

=== Verificación y uso en diseño

Predecir el alcance con precisión es difícil, y verificar la predicción experimentalmente, también. Por ejemplo, exigir $P_d = 0.90$ para un blanco de 1 $"m"^2$ a 200 nmi exige muchas observaciones para distinguir 0.90 de 0.80 o 0.95, y además hay que conocer la sección real, el aspecto, la refracción y el multitrayecto [L-91]. Una medida experimental habitual en radares de vigilancia aérea es la *razón de impactos por barrido* (_blip-scan ratio_), aproximación experimental a la probabilidad de detección por barrido: un avión vuela de ida y vuelta por un radial a altitud constante y se anota en cada barrido si se detecta [L-91] y [L-92]. Es un problema clásico de ensayos de Bernoulli, y para $N = 10$, $100$ y $1000$ ensayos y un valor medido de 0.80 el intervalo de confianza al 90 % es, respectivamente, 0.54–0.93, 0.73–0.86 y 0.78–0.82 [L-92] y [L-93]. Por ello la aceptación de un radar no se basa normalmente en medir su alcance, sino en especificar sus subsistemas (potencia del transmisor, ganancia de antena, figura de ruido, margen dinámico), que sí se pueden medir y de los que se calcula el rendimiento [L-93].

El autor recomienda no buscar una exactitud excesiva, pues los valores que entran en la ecuación son inciertos, aunque sin descuidos [L-93]. Para el cálculo bastan una calculadora y las gráficas del capítulo, y existen programas comerciales, útiles sobre todo para trazar diagramas de cobertura que incluyan el efecto de la superficie terrestre [L-93].

La ecuación del radar sirve también como base del diseño: unos parámetros (alcance, cobertura, características del blanco) los fija el cliente y el resto se elige por compromisos, como antena grande frente a transmisor potente, y la frecuencia debe salir de examinar la ecuación. Por la incertidumbre, conviene un diseño *conservador*: contar con todos los factores conocidos y añadir un margen en la relación señal/ruido (por ejemplo, usar Swerling 1 con $P_d >= 0.9$). Se ha llegado a diseñar con 20 dB de sobra, algo que hoy se considera excesivo y que el mercado y las prácticas de adquisición rara vez permiten [L-94].

#callout(kind: "info", title: [PARA EL CAPÍTULO 3])[
  El procesado Doppler y las pérdidas asociadas (blancos móviles en clutter, PRF múltiples, pulsos de relleno) quedan para el capítulo 3, y el tratamiento del clutter como límite de la detección para el capítulo 7 [L-85] y [L-89].
]
