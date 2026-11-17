#import "@tola/source:0.0.0": tola-meta
#import "/utils/ui.typ": callout, fold, hint, term
#import "/utils/diagram.typ": flow, n
#import "../../../figures/figuras_tema4_MICR.typ": fig-cambio-plano, fig-cascada, fig-cuadripolo-carga, fig-par-impar, fig-red-n-puertos, fig-red-t, fig-simetria-4p, fig-vna


#tola-meta((
  title: "[Tema 4] Redes de Microondas",
  date: "2026-11-05",
  summary: "Resumen del Tema 4 de Microondas: parámetros Z, Y y ABCD, ondas de potencia y parámetros S, ganancias de cuadripolos, conexión de redes y simetrías.",
  tags: ("microondas", "parámetros S", "redes", "resumen"),
))

#show math.equation: set text(
  font: "STIX Two Math",
)

#set math.equation(numbering: "(1)")

#set math.mat(delim: "[")
#set math.vec(delim: "[")

= Tema 4: Redes de Microondas

Hasta aquí se han estudiado las líneas y las guías de onda de una en una. Este tema da el paso siguiente: describir un circuito de microondas completo, formado por elementos concentrados y distribuidos, a partir únicamente de lo que ocurre en sus puertos. Primero se repasan las matrices de impedancias, de admitancias y ABCD, que se apoyan en tensiones y corrientes totales, y se explica por qué a frecuencias de microondas conviene sustituirlas por otra descripción. Esa descripción son los *parámetros S*, que relacionan ondas incidentes y reflejadas y se miden con un analizador de redes. Con ellos se calculan potencias y ganancias de cuadripolos, se conectan redes en cascada y se aprovechan las simetrías para simplificar el análisis.

#callout(kind: "info", title: [CÓMO LEER LAS REFERENCIAS])[Las marcas [P-4.n] remiten a la diapositiva n de la presentación del Tema 4. Las marcas [L-n] remiten a la página n del libro de Pozar (cuarta edición) y solo se usan cuando el contenido no aparece en las presentaciones. Bajo cada expresión relevante se indica dónde encontrarla durante el examen.]

== Introducción. Objetivos.

=== Qué es una red de microondas

Una *red de microondas* es un circuito formado por elementos discretos (bobinas, condensadores, resistencias) y/o distribuidos (líneas de transmisión) que realiza una función específica y al que se accede mediante #term("puertos")[Pares de terminales, o secciones de línea o de guía, por los que la red intercambia señal y potencia con el exterior.]. La definición y los objetivos del tema aparecen en [P-4.3]. En concreto, el tema persigue:

- repasar los parámetros Z e Y (impedancia y admitancia);
- conocer los parámetros S y sus ventajas para caracterizar redes de microondas;
- entender las ondas de potencia $a$ y $b$ y el coeficiente de reflexión;
- distinguir las redes pasivas, recíprocas y sin pérdidas;
- calcular potencias y ganancias con parámetros S;
- saber cómo cambian los parámetros S al mover el plano de referencia;
- analizar y diseñar circuitos con un simulador comercial.

Las redes están presentes en toda la cadena de comunicaciones. En transmisión intervienen el modulador, filtros, el mezclador con el oscilador local y el amplificador de potencia antes de la antena; en recepción, el filtro, el amplificador de bajo ruido (LNA), el mezclador, el amplificador de frecuencia intermedia y el demodulador [P-4.4]. Los circuitos físicos de N accesos se construyen con cada tecnología de línea:

- en coaxial, el divisor de potencia y el acoplador direccional [P-4.5];
- en guía de onda, el conmutador, el _twist_ de 90°, la transición coaxial-guía rectangular y los filtros en #term("SIW")[Guía de onda integrada en el sustrato (_substrate integrated waveguide_).] [P-4.6], además de redes de alimentación como el diplexor en banda Ku o un combinador de potencia de 17 puertas [P-4.7];
- en microstrip, el acoplador híbrido de 90° y las redes distribuidas que alimentan un array de antenas [P-4.8].

=== Tensiones y corrientes equivalentes en un puerto

Para tratar un puerto con teoría de circuitos hace falta una tensión y una corriente bien definidas. En una línea TEM lo están, pero en una guía no TEM no lo están de forma única: en el modo TE#sub[10] de una guía rectangular, por ejemplo, la tensión depende de la posición transversal y del camino de integración [L-168]. Por eso se definen una *tensión equivalente* y una *corriente equivalente* para cada modo, de modo que la tensión sea proporcional al campo eléctrico transversal, la corriente al campo magnético transversal, su producto dé la potencia del modo y el cociente entre ambas para una onda progresiva sea la impedancia característica $Z_0$, elegida normalmente igual a la impedancia de onda del modo o normalizada a la unidad [L-168]. Con esa convención, la pregunta de qué impedancia presenta una carga en una guía (diapositiva [P-4.9]) tiene sentido: se refiere a la impedancia del modo.

En el plano terminal $t$ del puerto ($z = 0$), la tensión y la corriente totales son la suma y la resta de las ondas progresiva (+) y regresiva (−) [P-4.11]:


$ V = V^+ + V^-, quad I = I^+ - I^- = Y_0 (V^+ - V^-), quad Y_0 = 1/Z_0 $ <eq-vi-puerto>


$ Z = V/I = Z_0 (V^+ + V^-)/(V^+ - V^-) $ <eq-z-puerto>

Estas expresiones se encuentran en [P-4.11].

Para una red de N puertos se repite lo anterior en cada puerto $i$, con su plano terminal $t_i$ y su impedancia característica $Z_(0 i)$. Las ondas con signo + entran en la red y las ondas con signo − salen de ella, y las corrientes totales se toman entrantes [P-4.12]:


$ V_i = V_i^+ + V_i^-, quad I_i = I_i^+ - I_i^-, quad I_i^+ = V_i^+/Z_(0 i), quad I_i^- = V_i^-/Z_(0 i) $ <eq-vi-n-puertos>

Esta expresión se encuentra en [P-4.12]. Los planos terminales fijan la referencia de fase de los fasores [L-174].

#fig-red-n-puertos()

#fold(title: [Detalle: cómo se fijan las constantes de la equivalencia])[
  Las tensiones y corrientes equivalentes de un modo se escriben como $V^plus.minus = C_1 A^plus.minus$ e $I^plus.minus = C_2 A^plus.minus$, donde $A^plus.minus$ son las amplitudes de campo del modo. Exigir que el producto de tensión y corriente dé la potencia del modo y que su cociente sea $Z_0$ determina las constantes [L-169]:

  $ C_1 C_2^* = integral_S bold(e) times bold(h)^* dot hat(z) dif S, quad Z_0 = C_1/C_2 $

  Para el modo TE#sub[10] de una guía rectangular de lados $a$ y $b$, con $Z_0 = Z_"TE"$, resulta [L-170]:

  $ C_1 = sqrt((a b)/2), quad C_2 = 1/Z_"TE" sqrt((a b)/2) $
]

=== Matrices de impedancias y de admitancias

La *matriz de impedancias* $[Z]$ y la *matriz de admitancias* $[Y]$ relacionan las tensiones y corrientes totales en los puertos, y son inversas una de otra siempre que $det [Z] != 0$ [P-4.13]:


$ [V] = [Z][I], quad [I] = [Y][V], quad [Y] = [Z]^(-1) $ <eq-zy>


$ V_i = sum_j Z_(i j) I_j $ <eq-zy-comp>

Estas expresiones se encuentran en [P-4.13] y [P-4.22]. Cada elemento se obtiene excitando un solo puerto y forzando condiciones en los demás [P-4.16], [P-4.21]:


$ Z_(i j) = lr(V_i/I_j |)_(I_k = 0 "para" k != j), quad Y_(i j) = lr(I_i/V_j |)_(V_k = 0 "para" k != j) $ <eq-zij-yij>

Estas expresiones se encuentran en [P-4.16] y [P-4.21]. En palabras, $Z_(i i)$ es la impedancia de entrada del puerto $i$ con el resto de puertos en circuito abierto, y $Z_(i j)$ es la impedancia de transferencia entre los puertos $i$ y $j$ con el resto en circuito abierto. De forma dual, $Y_(i j)$ se mide con el resto de puertos en cortocircuito [L-175]. Una red de N puertos tiene matrices $N times N$ de elementos complejos, es decir, $2 N^2$ grados de libertad en general, que la reciprocidad y la ausencia de pérdidas reducen [L-175].

=== Propiedades de la matriz de impedancias

Dos propiedades reducen los parámetros independientes de $[Z]$ [P-4.23]:

- si la red es pasiva, lineal e isótropa (recíproca), la matriz $[Z]$ es simétrica, lo que se conoce como teorema de reciprocidad, y esto se cumple incluso con pérdidas y sin simetría física;
- si la red es recíproca y no tiene pérdidas, todos los elementos de $[Z]$ son imaginarios puros, porque la potencia media entregada a la red es nula.


$ Z_(i j) = Z_(j i), quad op("Re")(Z_(i j)) = 0 "(red sin pérdidas)" $ <eq-z-propiedades>

Estas propiedades se encuentran en [P-4.23]. Ambas valen para líneas TEM, estructuras en guía y componentes discretos pasivos, y permiten sustituir la red por un circuito equivalente [P-4.23]. La matriz $[Y]$ cumple lo mismo y, si la red no tiene pérdidas, también es imaginaria pura [L-177].

La segunda propiedad sale del teorema de Poynting aplicado a la superficie $S$ que encierra la red, cuyo resultado relaciona la potencia compleja que entra por los puertos con la potencia disipada $P_L$ y con las energías magnética $W_H$ y eléctrica $W_E$ almacenadas [P-4.14]:


$ 1/2 integral.cont_S bold(E) times bold(H)^* dot hat(n) dif S = P_L + 2 j omega (W_H - W_E) = sum_(i=1)^N 1/2 V_i I_i^* $ <eq-poynting>

Esta expresión se encuentra en [P-4.14]. Si no hay pérdidas, $P_L = 0$ y la potencia compleja entregada tiene parte real nula. Con $[V] = [Z][I]$ y $[Z]$ simétrica, esa potencia es

$ P &= 1/2 [V]^t [I]^* = 1/2 ([Z][I])^t [I]^* \
  &= 1/2 [I]^t [Z] [I]^*. $

Si solo la corriente $I_n$ es no nula, queda $P = 1/2 Z_(n n) abs(I_n)^2$, luego $op("Re")(Z_(n n)) = 0$. Si solo $I_m$ e $I_n$ son no nulas, los términos diagonales ya son imaginarios puros y la parte real de $P$ vale $1/2 op("Re")(Z_(m n)) (I_n I_m^* + I_m I_n^*)$. El factor $I_n I_m^* + I_m I_n^*$ es real y, por ejemplo con $I_m = I_n = 1$, vale 2, así que $op("Re")(Z_(m n)) = 0$ [L-177].

=== Ejemplo: parámetros Z de una red en T y de una línea abierta

Sea la red en T de dos puertas con las impedancias $Z_A$ en serie en el puerto 1, $Z_B$ en serie en el puerto 2 y $Z_C$ en paralelo. Para $Z_11$ se abre el puerto 2 ($I_2 = 0$) y la tensión del puerto 1 es $V_1 = I_1 (Z_A + Z_C)$ [P-4.18]. Para $Z_12$ se excita el puerto 2 con $I_1 = 0$: no cae tensión en $Z_A$, así que $V_1$ es la tensión sobre $Z_C$, que se obtiene de $V_2$ con un divisor de tensión [P-4.19]. Para $Z_22$ se abre el puerto 1 [P-4.20]:


$ Z_11 &= lr(V_1/I_1 |)_(I_2 = 0) = Z_A + Z_C \
  Z_12 &= lr(V_1/I_2 |)_(I_1 = 0) = V_2/I_2 Z_C/(Z_B + Z_C) = Z_C \
  Z_22 &= lr(V_2/I_2 |)_(I_1 = 0) = Z_B + Z_C $ <eq-z-red-t>

Estas expresiones se encuentran en [P-4.18], [P-4.19] y [P-4.20]. Se comprueba que $Z_21 = Z_12$, como corresponde a un circuito recíproco [P-4.19].

#fig-red-t()

Como segundo ejemplo, los parámetros Z de una línea de longitud $l$ terminada en abierto: con $I_2 = 0$, el parámetro $Z_11$ es la impedancia de entrada con carga infinita [P-4.25]:


$ Z_11 = Z_"in" (Z_L -> infinity) = -j Z_0 cot(beta l) $ <eq-z-linea-abierta>

Esta expresión se encuentra en [P-4.25]. Se hace infinito para las longitudes que cumplen $beta l = n pi$ con $n = 0, 1, 2, dots$, de modo que la matriz $[Z]$ de ciertas redes no existe.

#callout(kind: "warning", title: [LIMITACIONES DE LA MATRIZ Z])[La matriz de impedancias es excelente para el cálculo, pero resulta antinatural: es difícil medir tensiones y corrientes, no describe de forma inmediata el comportamiento del circuito y sus coeficientes pueden hacerse infinitos, como en el tramo de línea del ejemplo anterior [P-4.24]. Además, el cálculo de $[Z]$, $[Y]$ o $[A B C D]$ de algunos circuitos da matrices singulares [P-4.37].]

=== Parámetros ABCD

Los *parámetros ABCD* describen una red de dos puertas por medio de las magnitudes del puerto 1 en función de las del puerto 2, con la corriente $I_2$ tomada saliente del puerto 2 [P-4.26]. Su ventaja es que son muy sencillos de operar y que la matriz de una conexión en cascada es el producto de las matrices de cada red, tomado en el orden de conexión [P-4.26], [P-4.27].


$ mat(V_1; I_1) = mat(A, B; C, D) mat(V_2; I_2) $ <eq-abcd>


$ A = lr(V_1/V_2 |)_(I_2 = 0), quad B = lr(V_1/I_2 |)_(V_2 = 0), quad C = lr(I_1/V_2 |)_(I_2 = 0), quad D = lr(I_1/I_2 |)_(V_2 = 0) $ <eq-abcd-elem>

Estas expresiones se encuentran en [P-4.26]. Para dos redes conectadas en cascada, la corriente de salida de la primera es la de entrada de la segunda, y por eso:


$ mat(V_1; I_1) = mat(A_1, B_1; C_1, D_1) mat(A_2, B_2; C_2, D_2) mat(V_3; I_3) $ <eq-abcd-cascada>

Esta expresión se encuentra en [P-4.27]. Como ejemplo, para una impedancia $Z$ en serie se obtiene $A = 1$, $B = Z$, $C = 0$ y $D = 1$ [P-4.28]. La tabla recoge los circuitos más habituales [P-4.29].

#figure(
  table(
    columns: 5,
    table.header[Circuito][$A$][$B$][$C$][$D$],
    [Impedancia $Z$ en serie], [$1$], [$Z$], [$0$], [$1$],
    [Admitancia $Y$ en paralelo], [$1$], [$0$], [$Y$], [$1$],
    [Línea ($Z_0$, $beta$, longitud $l$)], [$cos(beta l)$], [$j Z_0 sin(beta l)$], [$j Y_0 sin(beta l)$], [$cos(beta l)$],
    [Transformador N:1], [$N$], [$0$], [$0$], [$1/N$],
    [Red en T ($Z_1$, $Z_2$ en serie; $Z_3$ en paralelo)], [$1 + Z_1/Z_3$], [$Z_1 + Z_2 + (Z_1 Z_2)/Z_3$], [$1/Z_3$], [$1 + Z_2/Z_3$],
    [Red en $pi$ ($Y_1$, $Y_2$ en paralelo; $Y_3$ en serie)], [$1 + Y_2/Y_3$], [$1/Y_3$], [$Y_1 + Y_2 + (Y_1 Y_2)/Y_3$], [$1 + Y_1/Y_3$],
  ),
  caption: [Parámetros ABCD de algunos circuitos de dos puertas.],
) <tab-abcd>

Esta tabla se encuentra en [P-4.29]. Los parámetros ABCD se deducen de los parámetros Z, con el convenio de corriente saliente en el puerto 2, y para una red recíproca cumplen $A D - B C = 1$ [L-191]:


$ A = Z_11/Z_21, quad B = (Z_11 Z_22 - Z_12 Z_21)/Z_21, quad C = 1/Z_21, quad D = Z_22/Z_21 $ <eq-abcd-z>

Esta expresión se encuentra en [L-191]; el resto de conversiones entre parámetros de dos puertas está tabulado en [P-4.102].

#callout(kind: "warning", title: [SENTIDO DE LAS CORRIENTES])[En los parámetros Z e Y la corriente $I_2$ entra en el puerto 2, mientras que en los parámetros ABCD sale de él, para que sea la misma corriente que entra en la red siguiente de una cascada [P-4.26], [L-189]. Mezclar ambos convenios es una fuente habitual de errores de signo.]

=== Por qué hacen falta otros parámetros

A frecuencias de microondas (300 MHz – 300 GHz) las dimensiones físicas de pistas, componentes e integrados son comparables a la longitud de onda y aparecen efectos de propagación y radiación: las pistas se convierten en líneas de transmisión [P-4.30]. En ese régimen los puertos se implementan sobre líneas con impedancia característica $Z_(0 i)$ [P-4.31], y la medida de $[Z]$ o $[Y]$ choca con tres dificultades:

- *Condiciones de contorno imposibles.* Para medir $[Z]$ hay que dejar abierto el puerto 2 al medir $Z_11$ y $Z_21$ ($I_2 = 0$) y abierto el puerto 1 al medir $Z_12$ y $Z_22$ ($I_1 = 0$) [P-4.34]. Para medir $[Y]$ hay que cortocircuitar los puertos ($V_k = 0$) [P-4.36]. Estas condiciones pueden dañar los dispositivos.
- *Efecto de las líneas de conexión.* El medidor se conecta al dispositivo mediante líneas de impedancia $Z_0$, y la propagación hace que en los puertos de la red no haya un circuito abierto o un cortocircuito, sino otra impedancia o admitancia imaginaria que depende de la longitud de las líneas: $Z_1 != Z_1'$ y $Z_2 != Z_2'$ [P-4.35], [P-4.38]. Además, el medidor no mide $V_1$, $V_2$, $I_1$, $I_2$, sino $V_1'$, $V_2'$, $I_1'$, $I_2'$, también modificadas por las líneas [P-4.35], [P-4.38].
- *Falta de instrumentos.* A estas frecuencias no existen voltímetros ni amperímetros y la potencia pasa a ser la métrica principal, porque es más sencilla de medir y caracterizar [P-4.37].

#callout(kind: "success", title: [IDEA CLAVE])[A frecuencias de microondas sí se pueden medir con facilidad la relación de onda estacionaria, la potencia y las amplitudes y fases de las ondas reflejadas en un puerto respecto a la onda incidente [P-4.37]. Esto motiva un nuevo tipo de parámetros que no se basa en tensiones y corrientes totales, sino en las ondas progresivas y regresivas que ya se propagan por las líneas del sistema de medida: los *parámetros S* (_scattering_, de dispersión) [P-4.39].]

== Ondas de potencia. Parámetros S.

=== Idea de los parámetros S

La *matriz de dispersión* $[S]$ relaciona las ondas de tensión reflejadas con las incidentes en los puertos. Para dos puertas [P-4.40]:


$ mat(V_1^-; V_2^-) = mat(S_11, S_12; S_21, S_22) mat(V_1^+; V_2^+) $ <eq-s-tension>


$ S_11 = lr(V_1^-/V_1^+ |)_(V_2^+ = 0), quad S_12 = lr(V_1^-/V_2^+ |)_(V_1^+ = 0), quad S_21 = lr(V_2^-/V_1^+ |)_(V_2^+ = 0), quad S_22 = lr(V_2^-/V_2^+ |)_(V_1^+ = 0) $ <eq-s-elem-tension>

Estas expresiones se encuentran en [P-4.40] y [P-4.42]. Los elementos $S_11$ y $S_22$ relacionan la onda incidente con la reflejada en el mismo puerto, y $S_21$ y $S_12$ relacionan la incidente en un puerto con la transmitida al otro [P-4.43].

Para anular la onda incidente en un puerto basta conectar a él una impedancia igual a la impedancia característica de su línea, es decir, una carga adaptada [P-4.41]. Así, el medidor debe presentar $Z_0$ en el puerto 2 para medir $S_11$ y $S_21$, y en el puerto 1 para medir $S_12$ y $S_22$ [P-4.42]. Esto tiene dos ventajas frente a los parámetros Z e Y [P-4.44]:

- es más fácil implementar una impedancia constante en una banda de frecuencias que un cortocircuito o un circuito abierto perfectos;
- el valor de esa impedancia se refleja directamente en el puerto, porque la onda progresiva en una línea adaptada es nula en cualquier punto, sea cual sea su longitud.

Queda el inconveniente de medir $V_1'^-$ y $V_2'^-$ en lugar de $V_1^-$ y $V_2^-$, pero para ondas de tensión se resuelve incluyendo la longitud $l$ de la línea en la fase del fasor: el coeficiente de reflexión al inicio de la línea, $rho'$, y al final, $rho$, difieren solo en fase [P-4.44]:


$ phi_(rho') = phi_rho - 2 beta l $ <eq-fase-rho>

Esta expresión se encuentra en [P-4.44].

=== Potencia entregada a un puerto en función de V⁺ y V⁻

Cuando $Z_(0 i)$ es real y positiva, la potencia media entregada al circuito en el puerto $i$ es la potencia de la onda incidente menos la de la reflejada [P-4.45]:


$ P_(E i) = 1/(2 Z_(0 i)) (abs(V_i^+)^2 - abs(V_i^-)^2) $ <eq-pot-puerto-v>

Esta expresión se encuentra en [P-4.45]. Se obtiene de las tensiones y corrientes totales en función de las ondas, $V_i = V_i^+ + V_i^-$ e $I_i = (V_i^+ - V_i^-)/Z_(0 i)$ [P-4.45]:

$ P_(E i) &= 1/2 op("Re")(V_i I_i^*) \
  &= 1/(2 Z_(0 i)) op("Re")(abs(V_i^+)^2 - V_i^+ (V_i^-)^* + V_i^- (V_i^+)^* - abs(V_i^-)^2) \
  &= 1/(2 Z_(0 i)) (abs(V_i^+)^2 - abs(V_i^-)^2). $

El paso final se debe a que $V_i^- (V_i^+)^* - V_i^+ (V_i^-)^*$ es una diferencia de números complejos conjugados y, por tanto, imaginaria pura [P-4.45]. Invirtiendo las expresiones de $V_i$ e $I_i$ se tienen las ondas incidente y reflejada en función de magnitudes totales: $V_i^+ = (V_i + Z_(0 i) I_i)/2$ y $V_i^- = (V_i - Z_(0 i) I_i)/2$ [P-4.45].

=== Ondas de potencia a y b

Los parámetros S de tensión no dan información directa sobre la potencia. Para tenerla se normalizan las ondas de tensión y se definen las *ondas de potencia* [P-4.46]:


$ a_i = V_i^+/sqrt(Z_(0 i)), quad b_i = V_i^-/sqrt(Z_(0 i)) $ <eq-ab-def>


Esta expresión se encuentra en [P-4.46]. La onda $a_i$ es la onda incidente normalizada y $b_i$ la reflejada normalizada. Sus módulos al cuadrado miden potencias: $P_i^+ = abs(a_i)^2/2$ es la potencia de la onda incidente y $P_i^- = abs(b_i)^2/2$ la de la reflejada [P-4.54]. Por eso la potencia entregada al puerto es [P-4.49]:


$ P_(E i) = 1/2 op("Re")(V_i I_i^*) = 1/2 (abs(a_i)^2 - abs(b_i)^2) $ <eq-pot-puerto-ab>

Esta expresión se encuentra en [P-4.49]. Las relaciones con las tensiones y corrientes totales, directas e inversas, son [P-4.47]:


$ V_i = sqrt(Z_(0 i)) (a_i + b_i), quad I_i = 1/sqrt(Z_(0 i)) (a_i - b_i) $ <eq-vi-ab>



$ a_i = (V_i + Z_(0 i) I_i)/(2 sqrt(Z_(0 i))), quad b_i = (V_i - Z_(0 i) I_i)/(2 sqrt(Z_(0 i))) $ <eq-ab-vi>

Estas expresiones se encuentran en [P-4.47] y [P-4.49]. Con ellas la matriz de dispersión se expresa en ondas de potencia, para una red de N puertas [P-4.50]:


$ [B] = [S][A], quad S_(i j) = lr(b_i/a_j |)_(a_k = 0 "para" k != j) $ <eq-s-ab>

Esta expresión se encuentra en [P-4.47] y [P-4.50]. Los valores de $[S]$ dependen de las impedancias $Z_(0 i)$ usadas. Si $Z_(0 i) = 1$ (normalizada), las ondas de potencia coinciden con las de tensión [P-4.50].

#callout(kind: "warning", title: [SIN Z0 NO HAY S])[Las ondas de potencia no tienen sentido sin saber la impedancia $Z_(0 i)$ con la que se han definido [P-4.54]. Dos matrices S del mismo circuito referidas a impedancias distintas son matrices distintas.]

=== Ondas de potencia generalizadas

Si no hay una $Z_(0 i)$ real, por ejemplo con una línea con pérdidas o con un generador conectado directamente a una carga, se usa una impedancia de referencia $Z_"REF"$, en general compleja, con parte real $R_"REF"$ [P-4.51]:


$ a_i = (V_i + I_i Z_("REF" i))/(2 sqrt(R_("REF" i))), quad b_i = (V_i - I_i Z_("REF" i)^*)/(2 sqrt(R_("REF" i))) $ <eq-ab-gen>

Esta expresión se encuentra en [P-4.51]. Su inversa y la potencia entregada son [P-4.51]:


$ V_i = (Z_("REF" i)^* a_i + Z_("REF" i) b_i)/sqrt(R_("REF" i)), quad I_i = (a_i - b_i)/sqrt(R_("REF" i)), quad P_(E i) = 1/2 (abs(a_i)^2 - abs(b_i)^2) $ <eq-ab-gen-inv>

Estas expresiones se encuentran en [P-4.51]. La inversa se obtiene combinando las definiciones: multiplicando la de $a_i$ por $Z_("REF" i)^*$ y la de $b_i$ por $Z_("REF" i)$ y sumando se obtiene $V_i$, y restándolas se obtiene $I_i$. La potencia es proporcional a la diferencia de módulos al cuadrado porque, al desarrollar $op("Re")(V_i I_i^*)$, el término cruzado $Z_("REF" i) a_i^* b_i - Z_("REF" i)^* a_i b_i^*$ es imaginario puro. El resultado vale para cualquier impedancia de referencia.

Se distinguen dos casos [P-4.52]:

- si $Z_"REF" = Z_i$ es una impedancia en general compleja, las ondas son *generalizadas* y están relacionadas con la potencia incidente y reflejada en cada puerto;
- si $Z_"REF" = Z_(0 i)$ es real (impedancia característica de una línea o impedancia de un modo en una guía), las ondas son *no generalizadas*, relacionadas con las ondas incidentes y reflejadas en cada puerto. Son las que más se usan [P-4.52].

#callout(kind: "info", title: [ELECCIÓN DE LA REFERENCIA])[Con la referencia $Z_"REF" = Z_L^*$ la onda reflejada se anula, $b = 0$, pero eso no implica por sí mismo adaptación conjugada con el generador ni máxima potencia en la carga [L-187]. Además, con referencias generalizadas bien elegidas se pueden anular los elementos diagonales de la matriz S [L-188].]

=== La matriz S y el significado de sus elementos

Con ondas de potencia, $[S]$ tiene un significado directo [P-4.55], [P-4.56]:

- el elemento $S_(i i)$ es el *coeficiente de reflexión* del puerto $i$ cuando el resto de puertos está terminado en sus impedancias $Z_(0 j)$;
- el elemento $S_(j i)$ es el *coeficiente de transmisión* del puerto $i$ al puerto $j$ con el resto de puertos terminados en sus $Z_(0 k)$.


$ S_(i i) = lr(b_i/a_i |)_(a_j = 0 "para" j != i) = rho_i, quad S_(j i) = lr(b_j/a_i |)_(a_k = 0 "para" k != i) $ <eq-s-significado>

Esta expresión se encuentra en [P-4.55] y [P-4.56]. En el puerto $i$ el cociente entre onda reflejada e incidente es el coeficiente de reflexión de la impedancia $Z_(e i)$ vista desde el puerto [P-4.54]:


$ rho_i = b_i/a_i = V_i^-/V_i^+ = (Z_(e i) - Z_(0 i))/(Z_(e i) + Z_(0 i)) $ <eq-rho-puerto>


Esta expresión se encuentra en [P-4.54]. La relación con las ondas de tensión se deduce de $a_i$ y $b_j$ [P-4.55]:


$ S_(j i) = V_j^-/V_i^+ sqrt(Z_(0 i)/Z_(0 j)) $ <eq-s-tension-z0>

Esta expresión se encuentra en [P-4.55]. Si $Z_(0 j) = Z_(0 i) = Z_0$, se reduce al cociente de ondas de tensión de [P-4.40]. En términos de potencia, el cuadrado del módulo de cada elemento es una relación de potencias, y su expresión logarítmica da las pérdidas de retorno y de inserción [P-4.56]:


$ abs(S_(i i))^2 = "potencia reflejada en el puerto " i / "potencia disponible en el puerto " i, quad "RL"("dB") = -20 log abs(S_(i i)) $ <eq-rl>


$ abs(S_(j i))^2 = "potencia entregada al puerto " j / "potencia disponible en el puerto " i, quad "IL"("dB") = -20 log abs(S_(j i)) $ <eq-il>

Estas expresiones se encuentran en [P-4.56].

#callout(kind: "warning", title: [S_ii NO SIEMPRE ES EL COEFICIENTE DE REFLEXIÓN])[El coeficiente de reflexión visto desde el puerto $i$ coincide con $S_(i i)$ solo si el resto de puertos está terminado en sus impedancias de referencia. Los parámetros S son propiedades de la red y se definen con todos los puertos adaptados. Cambiar las terminaciones no cambia $[S]$, pero sí el coeficiente de reflexión visto en un puerto [L-184].]

=== Propiedades de la matriz S

La matriz de dispersión tiene dos propiedades básicas [P-4.57]:

- si la red es pasiva, lineal e isótropa (recíproca), la matriz $[S]$ es simétrica, de modo que $S_(i j) = S_(j i)$ (teorema de reciprocidad);
- si la red no tiene pérdidas ni ganancias, la matriz $[S]$ es unitaria, pues el balance de potencias es nulo. Cuando la red es recíproca, ambas propiedades se combinan.


$ [S] = [S]^t, quad [S]^dagger [S] = [U] $ <eq-s-propiedades>

Estas expresiones se encuentran en [P-4.57], donde la matriz unitaria se escribe $[S]^(t *) [S] = [U]$; el símbolo $dagger$ denota la conjugada traspuesta. Una red de N puertas recíproca tiene $(N^2 + N)/2$ parámetros distintos [P-4.58]; por ejemplo, la de 4 puertas queda con una matriz simétrica de 10 elementos independientes [P-4.58]. La idea física de la reciprocidad es que la relación entre respuesta y excitación se conserva al intercambiar los puertos de excitación y de respuesta: la tensión en circuito abierto del puerto $k$ por una fuente de corriente en el puerto $j$ es igual a la del puerto $j$ por la misma fuente en el puerto $k$, y análogamente para fuentes de tensión y corrientes de cortocircuito [P-4.59].

Los elementos de una matriz unitaria cumplen, además, relaciones por columnas [L-182]:


$ sum_(k=1)^N S_(k i) S_(k j)^* = delta_(i j) $ <eq-unitaria-comp>

Esta expresión se encuentra en [L-182]. Para $i = j$ la suma de $abs(S_(k i))^2$ vale 1 (la potencia sale íntegra por algún puerto), y para $i != j$ las columnas son ortogonales. En una red de dos puertas sin pérdidas se cumple $abs(S_11)^2 + abs(S_21)^2 = 1$, y si además es recíproca, $abs(S_11) = abs(S_22)$.

#fold(title: [Demostración de la simetría y de la unitariedad])[
  Se normalizan todos los puertos a $Z_0 = 1$, de modo que $[S] = ([Z] - [U])([Z] + [U])^(-1)$ [L-181]. Si la red es recíproca, $[Z]$ es simétrica y, al trasponer, $[S]^t = ([Z] + [U])^(-1) ([Z] - [U])$. Los dos factores son funciones de $[Z]$, luego conmutan, y resulta $[S]^t = [S]$ [L-181].

  Si la red no tiene pérdidas, la potencia total entregada es nula:

  $ 0 = 1/2 ([A]^dagger [A] - [B]^dagger [B]) = 1/2 [A]^dagger ([U] - [S]^dagger [S]) [A]. $

  La matriz $[U] - [S]^dagger [S]$ es hermítica y anula la forma cuadrática para todo vector $[A]$, de modo que es la matriz nula. Por tanto $[S]^dagger [S] = [U]$; la implicación inversa se comprueba leyendo el cálculo en sentido contrario [L-182].
]

#fold(title: [Ejemplo: red no recíproca y con pérdidas (Pozar, ejemplo 4.5)])[
  Sea la red de dos puertos con $S_11 = 0.15 angle 0 degree$, $S_12 = 0.85 angle -45 degree$, $S_21 = 0.85 angle 45 degree$ y $S_22 = 0.2 angle 0 degree$ [L-183]. No es simétrica, luego no es recíproca. Tampoco es sin pérdidas, porque $abs(S_11)^2 + abs(S_21)^2 = 0.745 != 1$. Con el puerto 2 adaptado, el coeficiente de reflexión en el puerto 1 es $S_11$, y la pérdida de retorno vale $-20 log(0.15) = 16.5$ dB. Con el puerto 2 en cortocircuito ($V_2^+ = -V_2^-$) el coeficiente de reflexión deja de ser $S_11$:

  $ rho = S_11 - (S_12 S_21)/(1 + S_22) = -0.452, quad "RL" = 6.9 "dB". $

  El ejemplo ilustra que $S_(i i)$ solo es el coeficiente de reflexión con los demás puertos adaptados [L-183].
]

=== Medida de parámetros S con un analizador de redes

La matriz S se mide con un #term("VNA")[Analizador vectorial de redes (_vector network analyzer_): instrumento que mide la amplitud y la fase de las ondas reflejadas y transmitidas por un dispositivo.] y describe el cambio, en amplitud y fase y para distintas frecuencias, de la onda reflejada y de la transmitida respecto a la incidente en el #term("DUT")[Dispositivo bajo prueba (_device under test_).] [P-4.60]. El VNA mide los parámetros S como relaciones de ondas de potencia complejas [P-4.61].

El plano de referencia primario de la medida suele estar dentro del analizador, de modo que la medida incluye las pérdidas y los desfases de conectores, cables y transiciones entre el plano de medida y el plano de referencia del DUT. Esos errores se aíslan con un proceso de *calibración* basado en estándares conocidos [P-4.61]. Una calibración habitual es la *TRL* (_Thru, Reflection, Line_) [P-4.62], [P-4.63]:

- _Thru_: conexión directa de los puertos 1 y 2 en el plano de interés;
- _Reflection_: una carga de alta reflectividad (un cortocircuito o un abierto) conectada individualmente a cada puerto;
- _Line_: ambos puertos conectados a través de un tramo de línea de transmisión adaptada.

#flow(
  dir: "ltr",
  n([Medir _Thru_, _Reflection_ y _Line_]),
  [datos],
  n([Algoritmo del VNA], tone: "accent"),
  [corrección],
  n([S del DUT sin error], tone: "dark"),
)

El VNA procesa las medidas de los tres estándares con un algoritmo que caracteriza el error, de modo que los parámetros S medidos en el DUT sean transparentes a él [P-4.62]. Cada estándar se modela con cajas de error a ambos lados del plano de referencia [P-4.64], y tras calibrar se verifican la adaptación y la transmisión [P-4.65].

#fig-vna()

#hint[Un VNA real usa un modelo de errores de 12 términos y puede mostrar SWR, pérdidas de retorno o retardo de grupo a partir de los parámetros S medidos [L-188].]

=== Cambio del plano de referencia

Mover los planos de referencia hacia fuera las longitudes eléctricas $theta_k = beta_k l_k$ solo cambia la fase de los parámetros S, no su módulo si la línea no tiene pérdidas [P-4.66], [L-185]. Con $[Phi]$ la matriz diagonal de exponenciales (denotada $[T]$ en las diapositivas) [P-4.67], [P-4.68]:


$ [a] = [Phi][a'], quad [b'] = [Phi][b], quad [Phi] = mat(e^(-j theta_1), 0; 0, e^(-j theta_2)) $ <eq-plano-ondas>


$ [S'] = [Phi][S][Phi] = mat(S_11 e^(-j 2 theta_1), S_12 e^(-j (theta_1 + theta_2)); S_21 e^(-j (theta_1 + theta_2)), S_22 e^(-j 2 theta_2)) $ <eq-plano-ref>


Estas expresiones se encuentran en [P-4.67] y [P-4.68]. La segunda se deduce de la primera: $[b'] = [Phi][b] = [Phi][S][a] = [Phi][S][Phi][a']$, y como $[b'] = [S'][a']$, resulta la relación buscada [P-4.68]. En general, $S'_(i j) = S_(i j) e^(-j (theta_i + theta_j))$.

#fig-cambio-plano()

La fase de $S_(k k)$ cambia el doble de la longitud eléctrica del desplazamiento, porque la onda recorre dos veces ese tramo, ida y vuelta [L-185]; es el resultado de [P-4.44] para el coeficiente de reflexión. Si los planos se trasladan hacia dentro, los exponentes son positivos. En líneas con pérdidas, $j beta$ se sustituye por la constante de propagación $gamma$ [P-4.69].

=== Relación entre las matrices S y Z

Sean $[F] = op("diag")(1/(2 sqrt(Z_(0 i))))$, $[G] = op("diag")(Z_(0 i))$ y $[U]$ la identidad. Entonces [P-4.70]:


$ [S] = [F]([Z] - [G])([Z] + [G])^(-1) [F]^(-1), quad [Z] = [F]^(-1) ([U] - [S])^(-1) ([U] + [S]) [F][G] $ <eq-s-z>

Esta expresión se encuentra en [P-4.70]. La segunda requiere que $[U] - [S]$ sea invertible. Para obtener la primera se escriben las ondas en forma matricial, $[A] = [F]([V] + [G][I])$ y $[B] = [F]([V] - [G][I])$, y se usa $[V] = [Z][I]$ [P-4.71]:

$ [A] &= [F]([Z] + [G])[I] arrow.double [I] = ([Z] + [G])^(-1) [F]^(-1) [A] \
  [B] &= [F]([Z] - [G])[I] = [F]([Z] - [G])([Z] + [G])^(-1) [F]^(-1) [A]. $

Como $[B] = [S][A]$, se obtiene la expresión de $[S]$. Para la inversa se parte de $[F]([V] - [G][I]) = [S][F]([V] + [G][I])$ y se sustituye $[V] = [Z][I]$ [P-4.72]:

$ ([F]([Z] - [G]) - [S][F]([Z] + [G])) [I] = 0 quad "para todo " [I]. $

Esto exige que $[F]([Z] - [G]) = [S][F]([Z] + [G])$, es decir, $([U] - [S])[F][Z] = ([U] + [S])[F][G]$, de donde se despeja $[Z]$ [P-4.72]. Con todos los puertos normalizados a $Z_0 = 1$ se recuperan $[S] = ([Z] - [U])([Z] + [U])^(-1)$ y $[Z] = ([U] + [S])([U] - [S])^(-1)$ [L-181]; para un puerto único, $S_11 = (z_11 - 1)/(z_11 + 1)$ con $z_11$ la impedancia normalizada [L-181].

=== Cálculo de S en redes de una y dos puertas

En una red de un puerto, $b = S a$ con $S = rho$, de modo que [P-4.73]:


$ S = rho = b/a = (V - Z_0 I)/(V + Z_0 I) = (Z_"in" - Z_0)/(Z_"in" + Z_0), quad Z_"in" = V/I $ <eq-s-un-puerto>

Esta expresión se encuentra en [P-4.73]. En una red de dos puertas con impedancias de referencia $Z_(0 1)$ y $Z_(0 2)$, $S_11$ y $S_21$ se calculan con $a_2 = 0$, lo que equivale a cargar el puerto 2 con $Z_(0 2)$, ya que $a_2 = 0$ si y solo si $V_2 = -Z_(0 2) I_2$ [P-4.75]:


$ S_11 = (V_1 - Z_(0 1) I_1)/(V_1 + Z_(0 1) I_1) = (Z_("in" 1) - Z_(0 1))/(Z_("in" 1) + Z_(0 1)), quad S_21 = sqrt(Z_(0 1)/Z_(0 2)) (2 V_2)/(V_1 + Z_(0 1) I_1) $ <eq-s-dos-puertos-1>


Aquí $Z_("in" 1) = V_1/I_1$ es la impedancia de entrada en el puerto 1 con el puerto 2 cargado con $Z_(0 2)$ [P-4.75]. Simétricamente, $S_12$ y $S_22$ se calculan con $a_1 = 0$, es decir, $V_1 = -Z_(0 1) I_1$ [P-4.76]:


$ S_22 = (V_2 - Z_(0 2) I_2)/(V_2 + Z_(0 2) I_2) = (Z_("in" 2) - Z_(0 2))/(Z_("in" 2) + Z_(0 2)), quad S_12 = sqrt(Z_(0 2)/Z_(0 1)) (2 V_1)/(V_2 + Z_(0 2) I_2) $ <eq-s-dos-puertos-2>


con $Z_("in" 2) = V_2/I_2$ la impedancia de entrada en el puerto 2 con el puerto 1 cargado con $Z_(0 1)$ [P-4.76]. Estas expresiones se encuentran en [P-4.75] y [P-4.76].

#fold(title: [Ejemplo: atenuador adaptado de 3 dB (Pozar, ejemplo 4.4)])[
  El atenuador en $pi$ de la figura tiene resistencias serie de 8.56 Ω y una paralelo de 141.8 Ω, con $Z_0 = 50$ Ω [L-179]. Con el puerto 2 adaptado, la impedancia de entrada es $8.56 + (141.8 (8.56 + 50))/(141.8 + 8.56 + 50) = 50$ Ω, luego $S_11 = 0$, y por simetría $S_22 = 0$ [L-180]. Dividiendo tensión dos veces se tiene $V_2^- = V_2 = 0.707 V_1$, así que $S_12 = S_21 = 0.707$ y la potencia de salida es la mitad de la de entrada, es decir −3 dB [L-180].
]

=== Matrices S de dispositivos comunes

Algunos dispositivos pasivos tienen matrices S muy sencillas, que se verán con más detalle en el Tema 5 [P-4.77]. La tabla las recoge junto con sus propiedades, que se comprueban con las condiciones de simetría y de unitariedad de la sección anterior.

#figure(
  table(
    columns: 4,
    table.header[Dispositivo][Matriz S][Recíproco][Sin pérdidas],
    [Aislador [P-4.77]], [$mat(0, 0; 1, 0)$], [No], [No],
    [Girador [P-4.77]], [$mat(0, -1; 1, 0)$], [No], [Sí],
    [Circulador de 3 puertas [P-4.78]], [$mat(0, 0, 1; 1, 0, 0; 0, 1, 0)$], [No], [Sí],
    [Acoplador en cuadratura [P-4.79]], [$1/sqrt(2) mat(0, -j, -1, 0; -j, 0, 0, -1; -1, 0, 0, -j; 0, -1, -j, 0)$], [Sí], [Sí],
  ),
  caption: [Matrices S de algunos dispositivos y sus propiedades.],
) <tab-s-dispositivos>

- El *aislador* transmite energía de radiofrecuencia en un solo sentido, y protege el dispositivo conectado a la entrada de lo que ocurra en el puerto de salida [P-4.77].
- El *girador* transmite sin cambios en un sentido y con un desfase de 180° en el contrario [P-4.77].
- El *circulador* permite transmitir la señal de un puerto al contiguo en un solo sentido, con 3 o 4 puertas [P-4.78].
- El *acoplador direccional en cuadratura* reparte por igual en magnitud la señal que entra por el puerto 1 entre los puertos 2 y 3, con el puerto 4 aislado a la frecuencia central y un desfase de 90° entre los puertos 2 y 3 [P-4.79].

El aislador no es unitario porque su segunda columna es nula, es decir, absorbe la potencia incidente en el puerto 2. En el acoplador, la matriz coincide con la del híbrido de 90° de Pozar [L-343]. Los ejemplos de [P-4.80], [P-4.81] y [P-4.82] muestran parámetros S de un diplexor en banda Ku y de antenas de parche, en dB frente a frecuencia, comparando el modelo de circuito con la simulación electromagnética.

== Cuadripolos. Potencias y ganancias. Cargados con Z0 y con ZG, ZL genéricas.

=== El cuadripolo referido a Z0 y sus coeficientes de reflexión

Un cuadripolo es una red de dos puertas cuya matriz $[S]$ está definida respecto a $Z_0$ en ambos puertos, lo que equivale a medirla con terminaciones $Z_0$ [P-4.83]:


$ b_1 = S_11 a_1 + S_12 a_2, quad b_2 = S_21 a_1 + S_22 a_2 $ <eq-cuadripolo>


Esta expresión se encuentra en [P-4.83]. Se conecta un generador de tensión $V_g$ e impedancia $Z_G$ al puerto 1 y una carga $Z_L$ al puerto 2. Cada impedancia tiene un coeficiente de reflexión referido a $Z_0$ [P-4.84]:


$ rho_X = (Z_X - Z_0)/(Z_X + Z_0), quad X in {G, E, S, L} $ <eq-rho-general>

Esta expresión se encuentra en [P-4.84]. Aquí $rho_G$ corresponde al generador, $rho_L$ a la carga, $rho_E$ a la impedancia $Z_E$ vista al mirar hacia la entrada del cuadripolo cargado con $Z_L$, y $rho_S$ a la impedancia $Z_S$ vista al mirar hacia la salida con el generador conectado. En Pozar se denotan $Gamma_"in"$ y $Gamma_"out"$ [L-560]. Las diapositivas escriben a veces $rho_g$ por $rho_G$.

#fig-cuadripolo-carga()

=== Potencias en el caso sencillo

Si el generador y la carga son $Z_0$ ($a_2 = 0$), las ondas se reducen a $b_1 = S_11 a_1$ y $b_2 = S_21 a_1$ y las potencias son [P-4.85]:


$ P_"dg" = abs(a_1)^2/2, quad P_"re" = abs(b_1)^2/2 = abs(S_11)^2 P_"dg", quad P_L = abs(b_2)^2/2 = abs(S_21)^2 P_"dg" $ <eq-pot-sencillo>

Esta expresión se encuentra en [P-4.85]. Las potencias del esquema son:

#figure(
  table(
    columns: 2,
    table.header[Símbolo][Significado],
    [$P_"dg"$], [potencia disponible del generador],
    [$P_"ee"$ ($= P_"in"$)], [potencia entregada a la entrada del cuadripolo],
    [$P_"re"$], [potencia reflejada en la entrada],
    [$P_"ds"$], [potencia disponible a la salida, la que se obtendría si $Z_L = Z_S^*$],
    [$P_"es"$ ($= P_L$)], [potencia entregada a la salida, es decir, a la carga],
    [$P_"rs"$], [potencia reflejada en la salida],
  ),
  caption: [Potencias que intervienen en un cuadripolo.],
) <tab-potencias>

Estas definiciones se encuentran en [P-4.85]. Que $Z_L = Z_0$ implique $rho_L = 0$ no significa que no haya reflexión en la salida: si $Z_S != Z_0$, entonces $rho_S != 0$ y $P_"rs" != 0$ [P-4.85]. Para una red pasiva, $P_L < P_"dg"$.

=== Tipos de ganancia

Hay tres definiciones de ganancia de potencia, que se diferencian en cómo se adaptan la fuente y la carga [P-4.86], [P-4.87]:


$ G_P = P_L/P_"in", quad G_A = P_"ds"/P_"dg", quad G_T = P_L/P_"dg" $ <eq-ganancias>


Esta expresión se encuentra en [P-4.86] y [P-4.87]. La *ganancia de potencia* (de transmisión u operativa) compara la potencia disipada en la carga con la suministrada a la entrada y no depende de $Z_S$. La *ganancia disponible* compara la potencia máxima disponible de la red con la disponible de la fuente, suponiendo adaptación compleja conjugada de fuente y carga, y depende de $Z_G$ pero no de $Z_L$. La *ganancia de transducción* compara la potencia entregada a la carga con la disponible de la fuente, depende de $Z_G$ y de $Z_L$, y es la más utilizada [P-4.87]. Si la entrada y la salida están adaptadas en sentido conjugado al cuadripolo, las tres coinciden [L-559].

=== Ganancias en el caso sencillo y pérdidas de inserción

Con $a_2 = 0$ y generador $Z_0$, la ganancia de transducción es el módulo al cuadrado de $S_21$ [P-4.88]:


$ G_T = P_"es"/P_"dg" = (abs(b_2)^2 \/ 2)/(abs(a_1)^2 \/ 2) = abs(S_21)^2, quad G_T("dB") = 20 log abs(S_21) $ <eq-gt-sencilla>

Las pérdidas de inserción son su inversa [P-4.88]:


$ "IL" = 1/G_T = P_"dg"/P_"es" = 1/abs(S_21)^2, quad "IL"("dB") = -20 log abs(S_21) $ <eq-il-gt>

Estas expresiones se encuentran en [P-4.88]. La ganancia de transducción depende de $Z_G$ y de $Z_L$, es la más representativa [P-4.88]. Para las otras dos ganancias, con $a_2 = 0$ [P-4.89], [P-4.90]:


$ G_P = P_"es"/P_"ee" = abs(S_21)^2/(1 - abs(S_11)^2), quad G_A = P_"ds"/P_"dg" = abs(S_21)^2/(1 - abs(S_22)^2) $ <eq-gp-ga-sencillas>

Estas expresiones se encuentran en [P-4.89] y [P-4.90]. Para la primera, la potencia entregada a la entrada es $P_"ee" = (abs(a_1)^2 - abs(b_1)^2)/2 = abs(a_1)^2 (1 - abs(S_11)^2)/2$. Para la segunda, con generador $Z_0$ el coeficiente de reflexión de salida es $rho_S = S_22$ y la potencia entregada a la carga $Z_0$ es la disponible por el factor de desadaptación, $P_"es" = P_"ds" (1 - abs(rho_S)^2)$, de donde sale $P_"ds"$ [P-4.90].

Las pérdidas de inserción se descomponen en dos factores [P-4.89]:


$ "IL" = 1/G_T = P_"dg"/P_"es" = underbrace(1/(1 - abs(S_11)^2), "reflexión") dot underbrace((1 - abs(S_11)^2)/abs(S_21)^2, "disipación") $ <eq-il-descomp>

Esta expresión se encuentra en [P-4.89]. El primer factor es la relación entre la potencia disponible y la que entra, y mide las pérdidas por reflexión. El segundo es la relación entre la potencia que entra y la que llega a la carga, y mide la disipación. En una red sin pérdidas, $1 - abs(S_11)^2 = abs(S_21)^2$ y el segundo factor vale 1.

=== Ganancia de transducción en el caso general

Con generador $V_g$, $Z_G$ y carga $Z_L$ cualesquiera, la ganancia de transducción es [P-4.93]:


$ G_T = (abs(S_21)^2 (1 - abs(rho_G)^2)(1 - abs(rho_L)^2))/abs((1 - S_11 rho_G)(1 - S_22 rho_L) - S_12 S_21 rho_G rho_L)^2 $ <eq-gt-general>

Esta expresión se encuentra en [P-4.93] y [P-4.94]. Con $rho_G = rho_L = 0$ se recupera $G_T = abs(S_21)^2$. Si el cuadripolo es unilateral ($S_12 = 0$), el denominador es $abs(1 - S_11 rho_G)^2 abs(1 - S_22 rho_L)^2$ [L-561].

#callout(kind: "warning")[En el caso general, $abs(a_1)^2/2$ no es $P_"dg"$: la onda $a_1$ depende de lo que refleje la red hacia el generador [P-4.91].]

El desarrollo parte de la onda $b_g$ que el generador lanzaría a una carga $Z_0$. Su potencia es $abs(b_g)^2/2$ y, como la potencia entregada a una carga $Z_0$ es la disponible por el factor de desadaptación, se cumple [P-4.92]:


$ P_(Z_0) = 1/2 abs(b_g)^2 = P_"dg" (1 - abs(rho_G)^2) arrow.double P_"dg" = abs(b_g)^2/(2 (1 - abs(rho_G)^2)) $ <eq-pdg-bg>

Esta expresión se encuentra en [P-4.92]. La onda incidente en el puerto 1 es la del generador más la que el generador devuelve de lo reflejado por la red, y la incidente en la carga es la reflejada por ella [P-4.93]:


$ a_1 = b_g + rho_G b_1, quad a_2 = rho_L b_2 $ <eq-a1-a2>

Como $P_"es" = (abs(b_2)^2 - abs(a_2)^2)/2 = abs(b_2)^2 (1 - abs(rho_L)^2)/2$, la ganancia queda [P-4.94]:

$ G_T = P_"es"/P_"dg" = (abs(b_2)^2 (1 - abs(rho_L)^2)(1 - abs(rho_G)^2))/abs(b_g)^2. $

Con $a_2 = rho_L b_2$ y $[B] = [S][A]$ se despejan las ondas de salida [P-4.94]:

$ b_2 &= (S_21 a_1)/(1 - S_22 rho_L), \
  b_1 &= S_11 a_1 + (S_12 rho_L S_21 a_1)/(1 - S_22 rho_L). $

Y de $b_g = a_1 - rho_G b_1$ resulta

$ b_g = a_1 ((1 - S_11 rho_G)(1 - S_22 rho_L) - S_12 S_21 rho_G rho_L)/(1 - S_22 rho_L). $

El cociente $b_2 \/ b_g$ elimina el factor $1 - S_22 rho_L$ y, sustituido en $G_T$, da @eq-gt-general.

Para las otras dos ganancias en el caso general, con $rho_E$ y $rho_S$ de la sección siguiente, se tienen estas expresiones de Pozar [L-560], [L-561]:


$ G_P = (abs(S_21)^2 (1 - abs(rho_L)^2))/((1 - abs(rho_E)^2) abs(1 - S_22 rho_L)^2), quad G_A = (abs(S_21)^2 (1 - abs(rho_G)^2))/(abs(1 - S_11 rho_G)^2 (1 - abs(rho_S)^2)) $ <eq-gp-ga-general>

Estas expresiones se encuentran en [L-560] y [L-561].

=== Impedancia de entrada y de salida

El coeficiente de reflexión visto desde la entrada con carga $Z_L$ y el visto desde la salida con generador $Z_G$ son [P-4.95], [P-4.96]:


$ rho_E = b_1/a_1 = S_11 + (S_12 S_21 rho_L)/(1 - S_22 rho_L), quad rho_S = S_22 + (S_12 S_21 rho_G)/(1 - S_11 rho_G) $ <eq-rho-e-s>

Estas expresiones se encuentran en [P-4.95] y [P-4.96]. Las impedancias correspondientes salen de invertir @eq-rho-general, $Z_E = Z_0 (1 + rho_E)/(1 - rho_E)$ y $Z_S = Z_0 (1 + rho_S)/(1 - rho_S)$ [L-560]. Con $rho_L = 0$ se tiene $rho_E = S_11$, lo que confirma que $S_11$ es el coeficiente de reflexión de entrada con la salida adaptada.

Para $rho_E$ se sustituye $a_2 = rho_L b_2$ en $b_2 = S_21 a_1 + S_22 a_2$, de modo que $b_2 = S_21 a_1 \/ (1 - S_22 rho_L)$, y se lleva a $b_1 = S_11 a_1 + S_12 a_2$ [P-4.95]. Para $rho_S$ se apaga el generador, $b_g = 0$, de modo que $a_1 = rho_G b_1$. De $b_1 = S_11 rho_G b_1 + S_12 a_2$ se tiene $b_1 = S_12 a_2 \/ (1 - S_11 rho_G)$, y llevándolo a $b_2 = S_21 rho_G b_1 + S_22 a_2$ se obtiene $rho_S = b_2 \/ a_2$ [P-4.96].

=== Conexión de cuadripolos en cascada

Se busca la matriz $[S]$ de la cascada de dos cuadripolos. La dificultad es que entre ellos hay varios caminos, por las reflexiones múltiples [P-4.97]. Si ambos están referidos a la misma $Z_0$, las ondas en el plano de unión cumplen $b_2^([1]) = a_1^([2])$ y $a_2^([1]) = b_1^([2])$ [P-4.98], y el resultado, con $D = 1 - S_22^([1]) S_11^([2])$, es [P-4.99]:


$ [S] = mat(S_11^([1]) + (S_12^([1]) S_11^([2]) S_21^([1]))/D, (S_12^([1]) S_12^([2]))/D; (S_21^([1]) S_21^([2]))/D, S_22^([2]) + (S_21^([2]) S_22^([1]) S_12^([2]))/D) $ <eq-cascada-s>


Esta expresión se encuentra en [P-4.99]. Con los puertos numerados 1, 2 (primera red) y 3, 4 (segunda red), el resultado tiene la forma [P-4.99]:


$ [S] = mat(S_11 + (S_12 S_33 S_21)/(1 - S_22 S_33), (S_12 S_34)/(1 - S_22 S_33); (S_43 S_21)/(1 - S_22 S_33), S_44 + (S_43 S_22 S_34)/(1 - S_22 S_33)) $ <eq-cascada-s-4p>

Esta expresión se encuentra en [P-4.99]. El factor $1\/D$ recoge las reflexiones múltiples: si $abs(S_22^([1]) S_11^([2])) < 1$, es la suma $1 + x + x^2 + dots$ con $x = S_22^([1]) S_11^([2])$, y cada término añade un viaje de ida y vuelta entre las dos redes.

#fig-cascada()

Para deducirlo, con $a_1$ y $a_2$ las ondas incidentes externas, se escriben las ecuaciones de cada red y se aplican las condiciones de unión [P-4.98]:

$ b_2^([1]) &= S_21^([1]) a_1 + S_22^([1]) b_1^([2]), \
  b_1^([2]) &= S_11^([2]) b_2^([1]) + S_12^([2]) a_2. $

Resolviendo este sistema se obtienen $b_2^([1])$ y $b_1^([2])$, y con $b_1 = S_11^([1]) a_1 + S_12^([1]) b_1^([2])$ y $b_2 = S_21^([2]) b_2^([1]) + S_22^([2]) a_2$ aparecen los cuatro elementos de @eq-cascada-s.

=== Cascada con distintas impedancias de referencia

El método anterior no se puede aplicar si las matrices están referidas a impedancias de normalización distintas, $Z_(0 1)$ y $Z_(0 2)$ [P-4.100]. Hay varias salidas:

- pasar de $[S]$ referida a $Z_(0 1), dots, Z_(0 n)$ a $[Z]$ o $[A B C D]$, que no dependen de $Z_0$, operar y volver a $[S]$ con las nuevas referencias [P-4.100];
- relacionar las ondas de potencia en la unión, que no coinciden ($b_2 approx a_3$ y $a_2 approx b_3$) porque están normalizadas con impedancias distintas; se obtienen de las definiciones de $a_i$ y $b_i$ imponiendo continuidad de tensión y de corriente [P-4.100].

Las matrices ABCD se multiplican directamente [P-4.101]:


$ mat(V_1; I_1) = mat(A_1, B_1; C_1, D_1) mat(V_2; I_2), quad mat(V_2; I_2) = mat(A_2, B_2; C_2, D_2) mat(V_3; I_3) $ <eq-abcd-dos-redes>


Esta expresión se encuentra en [P-4.101]. Para pasar entre $[S]$ y $[A B C D]$ con la misma $Z_0$ en ambos puertos se usan las conversiones de [P-4.102]; por ejemplo, la matriz de dispersión en función de $[A B C D]$ es [P-4.102]:


$ S_11 = (A + B\/Z_0 - C Z_0 - D)/(A + B\/Z_0 + C Z_0 + D), quad S_12 = (2 (A D - B C))/(A + B\/Z_0 + C Z_0 + D) \
  S_21 = 2/(A + B\/Z_0 + C Z_0 + D), quad S_22 = (-A + B\/Z_0 - C Z_0 + D)/(A + B\/Z_0 + C Z_0 + D) $ <eq-s-abcd>

Esta expresión se encuentra en [P-4.102]. Con referencias distintas, el camino es pasar de $[S]$ a $[Z]$ con @eq-s-z y de $[Z]$ a $[A B C D]$ con @eq-abcd-z.

=== Conexión de cuadripolos con matrices T

La *matriz T* (de transmisión) invierte el orden de las ondas en entrada y salida, y por eso la cascada es un producto de matrices [P-4.103], [P-4.104]:


$ mat(a_1; b_1) = mat(T_11, T_12; T_21, T_22) mat(b_2; a_2) $ <eq-t-def>



$ T_11 = 1/S_21, quad T_12 = -S_22/S_21, quad T_21 = S_11/S_21, quad T_22 = S_12 - (S_11 S_22)/S_21 $ <eq-t-de-s>


Estas expresiones se encuentran en [P-4.103]. Se deducen de $b_2 = S_21 a_1 + S_22 a_2$, de donde $a_1 = b_2/S_21 - (S_22/S_21) a_2$, y de $b_1 = S_11 a_1 + S_12 a_2 = (S_11/S_21) b_2 + (S_12 - S_11 S_22/S_21) a_2$ [P-4.103]. La inversa es [P-4.105]:


$ S_11 = T_21/T_11, quad S_12 = T_22 - (T_12 T_21)/T_11, quad S_21 = 1/T_11, quad S_22 = -T_12/T_11 $ <eq-s-de-t>


Esta expresión se encuentra en [P-4.105]. Para dos redes con la misma $Z_0$, las ondas en la unión cumplen $mat(b_2^([1]); a_2^([1])) = mat(a_1^([2]); b_1^([2]))$, de modo que [P-4.104]:


$ [T] = [T^([1])][T^([2])] $ <eq-t-cascada>

Esta expresión se encuentra en [P-4.104]. El procedimiento queda resumido en [P-4.106]:

#flow(
  dir: "ltr",
  n([Matrices $[S]$ de cada red]),
  [pasar a T],
  n([Producto de las $[T]$], tone: "accent"),
  [volver a S],
  n([$[S]$ de la cascada], tone: "dark"),
)

#callout(kind: "info", title: [NO CONFUNDIR LAS MATRICES T])[La matriz $[T]$ de esta sección no es la matriz diagonal del cambio de plano de referencia, que se ha escrito $[Phi]$. Solo comparten letra en las diapositivas.]

=== Redes multipuerta

Una red compleja se analiza descomponiéndola en redes más simples y obteniéndola mediante su conexión, con métodos generales y sistemáticos. Hay dos casos: terminales conectados a generadores y cargas, y terminales libres [P-4.108]. Sea una red formada por $m$ componentes conectados de forma arbitraria; sus accesos libres son los accesos de la red, con $[B] = [S][A]$ [P-4.109].

Si el puerto $l$ de un multipolo se conecta al puerto $m$ de otro con la misma $Z_0$, la unión impone $b_l = a_m$ y $b_m = a_l$ [P-4.110]:


$ mat(b_l; b_m) = mat(0, 1; 1, 0) mat(a_l; a_m) quad arrow.double quad [B] = [Gamma][A] $ <eq-union-puertos>

Esta expresión se encuentra en [P-4.110]. Para toda la red se separan los puertos libres $P$ y los puertos conectados $C$, y $[Gamma]$ es la matriz de unos que intercambia cada pareja de puertos conectados [P-4.111]:


$ mat(b_P; b_C) = mat(S_(P P), S_(P C); S_(C P), S_(C C)) mat(a_P; a_C), quad b_C = [Gamma] a_C $ <eq-multipuerta-base>

Esta expresión se encuentra en [P-4.111]. De la segunda fila, $[Gamma] a_C = S_(C P) a_P + S_(C C) a_C$, se despeja $a_C = ([Gamma] - S_(C C))^(-1) S_(C P) a_P$, siempre que $[Gamma] - S_(C C)$ sea invertible, y se sustituye en la primera fila, $b_P = S_(P P) a_P + S_(P C) a_C$ [P-4.111]. El resultado es la matriz de la red con los puertos libres:


$ [S_P] = S_(P P) + S_(P C) ([Gamma] - S_(C C))^(-1) S_(C P) $ <eq-multipuerta>


Esta expresión se encuentra en [P-4.111]. La cascada de @eq-cascada-s es un caso particular.

=== Simetrías en redes de dos puertas

Si una red de dos puertas es recíproca y simétrica, entonces $S_11 = S_22$ y $S_12 = S_21$, y sus parámetros salen de dos medidas de un puerto sobre media red [P-4.112], [P-4.114]. Se excita con $a_2 = -a_1$ (modo impar), lo que equivale a una pared eléctrica o cortocircuito en el plano de simetría, y con $a_2 = a_1$ (modo par), lo que equivale a una pared magnética o circuito abierto [P-4.112]:

$ "impar" (a_2 = -a_1): & quad S_(11 O) = rho_"cc" = b_1/a_1 = S_11 - S_21 \
  "par" (a_2 = a_1): & quad S_(11 E) = rho_"ca" = b_1/a_1 = S_11 + S_21 $

De la suma y de la resta de ambas ecuaciones [P-4.113]:


$ S_11 = S_22 = (S_(11 E) + S_(11 O))/2, quad S_12 = S_21 = (S_(11 E) - S_(11 O))/2 $ <eq-simetria-2p>


Esta expresión se encuentra en [P-4.113] y [P-4.114]. Aquí $S_(11 O)$ es el $S_11$ de la geometría con excitación impar y $S_(11 E)$ el de la excitación par.

#fig-par-impar()

=== Simetrías en redes de cuatro puertas

Sea una red de cuatro puertas con un plano de simetría que separa los puertos 1 y 2 de los puertos 4 y 3 [P-4.115], [P-4.116]. Aunque no sea recíproca, la simetría deja ocho incógnitas [P-4.116]:

$ S_11 &= S_44, quad S_22 = S_33, quad S_14 = S_41, quad S_23 = S_32, \
  S_21 &= S_34, quad S_12 = S_43, quad S_31 = S_24, quad S_13 = S_42. $

#fig-simetria-4p()

Descomponiendo en excitación par (pared magnética) e impar (pared eléctrica) se obtienen dos redes de dos puertas con matrices $[S_E]$ y $[S_O]$ [P-4.115], y los parámetros son [P-4.117]:


$ S_11 = S_44 &= (S_(11 E) + S_(11 O))/2, & quad S_33 = S_22 &= (S_(22 E) + S_(22 O))/2 \
  S_34 = S_21 &= (S_(21 E) + S_(21 O))/2, & quad S_43 = S_12 &= (S_(12 E) + S_(12 O))/2 \
  S_13 = S_42 &= (S_(12 E) - S_(12 O))/2, & quad S_31 = S_24 &= (S_(21 E) - S_(21 O))/2 \
  S_14 = S_41 &= (S_(11 E) - S_(11 O))/2, & quad S_23 = S_32 &= (S_(22 E) - S_(22 O))/2 $ <eq-simetria-4p>

Esta expresión se encuentra en [P-4.117].

Si la red tiene además un segundo plano de simetría, perpendicular al primero, se excita con cuatro combinaciones de paredes: la primera indicada es la del plano horizontal y la segunda la del vertical [P-4.118]. En cada caso se calcula el coeficiente de reflexión $rho_k$ en el puerto 1 [P-4.118], [P-4.119]:

$ "(c.a./c.a.):" & cases(a_1 = a_2 = a_3 = a_4 = a, rho_1 = S_11 + S_12 + S_13 + S_14) \
  "(c.a./c.c.):" & cases(a_1 = a_4 = a, a_2 = a_3 = -a, rho_2 = S_11 - S_12 - S_13 + S_14) \
  "(c.c./c.a.):" & cases(a_1 = a_2 = a, a_3 = a_4 = -a, rho_3 = S_11 + S_12 - S_13 - S_14) \
  "(c.c./c.c.):" & cases(a_1 = a_3 = a, a_2 = a_4 = -a, rho_4 = S_11 - S_12 + S_13 - S_14) $

Esto se encuentra en [P-4.118] y [P-4.119]. Sumando y restando las cuatro ecuaciones con los signos adecuados se despejan los elementos de la primera fila [P-4.119], [P-4.120]:


$ S_11 = (rho_1 + rho_2 + rho_3 + rho_4)/4, quad S_12 = (rho_1 - rho_2 + rho_3 - rho_4)/4 \
  S_13 = (rho_1 - rho_2 - rho_3 + rho_4)/4, quad S_14 = (rho_1 + rho_2 - rho_3 - rho_4)/4 $ <eq-simetria-4p-rho>

Esta expresión se encuentra en [P-4.120], donde se escribe $S_21$, $S_31$ y $S_41$ en lugar de $S_12$, $S_13$ y $S_14$. Es correcto porque con dos planos de simetría $S_(j 1) = S_(1 j)$. Las ocho igualdades de [P-4.116] y la segunda simetría implican entonces la forma:

$ [S] = mat(S_11, S_12, S_13, S_14; S_12, S_11, S_14, S_13; S_13, S_14, S_11, S_12; S_14, S_13, S_12, S_11). $

#callout(kind: "info", title: [APLICACIÓN: ACOPLADOR EN CUADRATURA])[El híbrido de 90° de Pozar se analiza con este método: con $Gamma_e = Gamma_o = 0$, $T_e = -(1 + j)/sqrt(2)$ y $T_o = (1 - j)/sqrt(2)$, resultan $B_1 = 0$, $B_2 = -j/sqrt(2)$, $B_3 = -1/sqrt(2)$ y $B_4 = 0$, la primera columna de la matriz de [P-4.79] [L-344], [L-345].]
