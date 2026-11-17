#import "@tola/source:0.0.0": tola-meta
#import "/utils/ui.typ": callout, fold, hint, term
#import "/utils/diagram.typ": flow, n as nd

#tola-meta((
  title: "[Tema 5] Ecualización",
  date: "2026-11-11",
  summary: "Resumen del tema 5 de Transmisión Digital (UPM): MLSD con el algoritmo de Viterbi, ecualización lineal ZF y MMSE, ecualización adaptativa FIR (Wiener, descenso por gradiente y LMS) y complemento sobre el DFE.",
  tags: ("transmisión digital", "ecualización", "resumen", "UPM"),
))

#show math.equation: set text(
  font: "STIX Two Math",
)

#set math.equation(numbering: "(1)")

// Localización de las expresiones en el material de la asignatura:
// P-tema.diapositiva (presentaciones), A-capítulo.página (apuntes), L-página (libro de Barry).
#let loc(x, plural: false) = text(
  size: 0.85em,
  (if plural { "Estas expresiones se encuentran en" } else { "Esta expresión se encuentra en" }) + " [" + x + "].",
)

#let argmin = math.op("arg min", limits: true)

= Tema 5. Ecualización

Este tema estudia la transmisión sobre canales selectivos en frecuencia, que introducen #term("ISI")[Interferencia intersimbólica: la muestra recibida en un instante contiene, además del símbolo deseado, contribuciones de los símbolos vecinos.]. Con ISI, decidir símbolo a símbolo da prestaciones inaceptables. El problema pasa a ser estimar una *secuencia* completa, y para ello se estudian dos familias de soluciones: el detector de secuencia de máxima verosimilitud (*MLSD*), óptimo pero costoso, y los *ecualizadores*, que deshacen (deconvolucionan) el efecto del canal con un filtro. Las referencias de ubicación se escriben como [P-tema.diapositiva] (presentaciones), [A-capítulo.página] (apuntes) y [L-página] (libro de Barry).

== Introducción

=== Objetivo y visión general

El objetivo es tratar transmisiones sobre canales con ISI. La detección símbolo a símbolo deja de ser válida y la estimación de símbolos debe interpretarse como una estimación de la secuencia completa. Las implementaciones que mitigan la ISI son:

- *MLSD* mediante el algoritmo de Viterbi.
- *Deconvolución*: ecualización IIR lineal y no lineal (con realimentación de decisiones) y ecualización lineal FIR.

#callout(kind: "info", title: [NIVEL DE ISI])[Descomponiendo la muestra en el símbolo actual (#term("cursor")[Símbolo que se desea detectar en el instante actual, situado en el retardo $d$ donde $p[d]$ es máximo.]) y el resto, que actúa como interferencia, se define el nivel de ISI $gamma_"ISI"$. Si $gamma_"ISI" > 1$, el diagrama de ojo está cerrado y aparecen errores de decisión incluso sin ruido.

$ q[n] = p[d] A[n-d] + sum_(k != d) p[k] A[n-k] + n[n] \
  gamma_"ISI" = D_"peak"/eta, quad D_"peak" = sum_(k != d) abs(p[k])/abs(p[d]), quad eta = (d_"min"/2)/abs(A)_"max" $ <eq-isi>

#loc("A-1.10") Un multitrayecto severo implica mucha ISI, y una constelación densa (con $d_"min"$ pequeña) es poco robusta frente a ella.]

=== Relaciones estocásticas entrada-salida en sistemas LTI

Si un proceso estacionario en sentido amplio $X[n]$ entra en un sistema lineal e invariante con respuesta al impulso $h[n]$, la salida $Y[n]$ también es estacionaria en sentido amplio, y sus estadísticos de primer y segundo orden se obtienen a partir de los de la entrada y de $H$. Esto se usará repetidamente: en el modelo del canal, en el ecualizador MMSE y en el filtro de Wiener.

Los estadísticos de la entrada son la media $mu_X$, la autocorrelación y la densidad espectral de potencia (transformada de Fourier de la autocorrelación; $S_X (z)$ es su transformada $Z$ y $S_X (e^(j omega)) = S_X (z)|_(z = e^(j omega))$ dentro de la región de convergencia estable):

$ R_X [m] = EE[X[n+m] X^*[n]], quad S_X (e^(j omega)) = sum_(m=-oo)^oo R_X [m] e^(-j omega m) $ <eq-estad-entrada>

#loc("P-5.6")

$ P_X = sigma_X^2 + mu_X^2 = R_X [0] = 1/(2 pi) integral_(-pi)^pi S_X (e^(j omega)) dif omega $ <eq-potencia>

#loc("P-5.6")

Para la salida se obtiene:

$ EE[Y[n]] &= mu_X H(e^(j 0)) \
  R_Y [m] &= R_X [m] * h[m] * h^*[-m] \
  S_Y (e^(j omega)) &= S_X (e^(j omega)) abs(H(e^(j omega)))^2 \
  S_Y (z) &= S_X (z) H(z) H^*(1/z^*) $ <eq-salida>

#loc("P-5.7")

Si $h[m]$ es real, se cumple $h^*[-m] = h[-m]$ y $H^*(1/z^*) = H(z^(-1))$. Las estadísticas cruzadas, que se usarán para el filtro de Wiener, son:

$ R_(X Y)[m] &= R_X [m] * h^*[-m], quad & R_(Y X)[m] &= R_X [m] * h[m] \
  S_(X Y)(z) &= S_X (z) H^*(1/z^*), quad & S_(Y X)(z) &= S_X (z) H(z) $ <eq-cruzadas>

#loc("P-5.8")

=== Modelo discreto equivalente

El resultado central es que todo el sistema (modulador lineal, canal, ruido, filtro receptor y muestreador) equivale a un canal discreto $P(z)$ seguido de ruido blanco aditivo. Sobre ese modelo se diseñan el MLSD y los ecualizadores.

#flow(
  dir: "ltr",
  nd[$A[n]$],
  nd([$P(z)$], tone: "accent"),
  [$s[n]$],
  nd([Ruido aditivo], sub: [blanco, potencia $sigma_n^2$]),
  [$q[n]$],
  nd([Detector / ecualizador], tone: "dark"),
)

La señal transmitida es $s(t) = sum_n A[n] g(t - n T)$ y el receptor aplica el filtro $g^*(-t)$ y muestrea cada $T$. Llamando $p(t)$ a la respuesta del conjunto pulso, canal y filtro receptor:

$ p(t) = g(t) * h(t) * g^*(-t), quad p[n] = p(n T), quad P(z) = sum_(n=-oo)^oo p[n] z^(-n) $ <eq-p-equiv>

#loc("P-5.13")

Los símbolos son blancos de potencia $sigma_A^2$. La parte de señal $s[n] = A[n] * p[n]$ tiene entonces densidad espectral coloreada:

$ s[n] = A[n] * p[n], quad S_s (e^(j omega)) = S_A (e^(j omega)) abs(P(e^(j omega)))^2 = sigma_A^2 abs(P(e^(j omega)))^2 $ <eq-senal-equiv>

#loc("P-5.11")

El ruido filtrado $q_n (t)$ no es blanco antes de muestrear, pero sí después. Con ruido $z(t)$ blanco de densidad $N_0$, su autocorrelación es $R_(q_n)(tau) = N_0 integral g(t + tau) g^*(t) dif t$, y en los instantes $m T$ vale $N_0 delta[m]$ porque los pulsos $g(t - n T)$ son ortonormales (la autocorrelación del pulso cumple el criterio de Nyquist). Por tanto, el ruido muestreado es blanco:

$ R_n [m] = R_(q_n)(m T) = N_0 delta[m] = sigma_n^2 delta[m], quad S_n (e^(j omega)) = sigma_n^2 $ <eq-ruido-equiv>

#loc("P-5.12")

Reuniendo señal y ruido se llega al modelo del tema:

$ q[n] = s[n] + n[n] = sum_(k=-oo)^oo p[k] A[n-k] + n[n] $ <eq-modelo>

#loc("P-5.13")

#callout(kind: "warning", title: [FILTRO RECEPTOR NO ÓPTIMO])[Este esquema no es óptimo con ISI: el filtro receptor debería adaptarse a la combinación $g(t) * h(t)$ del pulso y el canal, y no solo a $g(t)$. #loc("A-1.10")]

== Detector de secuencia de máxima verosimilitud (MLSD)

=== Criterio de decisión

Con ISI el detector símbolo a símbolo deja de ser óptimo y hace falta un detector con memoria. El MLSD elige, entre las $M^L$ secuencias posibles ($M$ puntos de la constelación y $L$ la longitud de la secuencia), la más verosímil. Si los símbolos son independientes y equiprobables, todas las secuencias $bold(A)_j$ tienen igual probabilidad a priori, y el criterio MAP coincide con el de máxima verosimilitud (ML). #loc("P-5.15")

Para un canal con $K + 1$ coeficientes:

$ q[n] = sum_(k=0)^K p[k] A[n-k] + n[n] $ <eq-q-fir>

#loc("P-5.17")

Se agrupan $L$ observaciones y símbolos en los vectores $bold(q) = (q[0], dots, q[L-1])^T$ y $bold(A) = (A[0], dots, A[L-1])^T$. Condicionado a $bold(A)$, el vector $bold(q)$ es gaussiano porque el ruido lo es, con media $mu_n = sum_(k=0)^K p[k] A[n-k]$ y matriz de covarianzas $sigma_n^2 bold(I)$. Para ruido real, su densidad es:

$ f_(bold(q)|bold(A))(bold(q)|bold(A)) = 1/((2 pi sigma_n^2)^(L/2)) exp(-1/(2 sigma_n^2) sum_(n=0)^(L-1) abs(q[n] - sum_(k=0)^K p[k] A[n-k])^2) $ <eq-pdf-mlsd>

#loc("P-5.18")

Maximizar esta densidad equivale a minimizar la distancia euclídea entre la observación y la secuencia filtrada por el canal sin ruido:

$ hat(bold(A))_"ML" = argmin_(bold(A)) sum_(n=0)^(L-1) abs(q[n] - sum_(k=0)^K p[k] A[n-k])^2 $ <eq-mlsd>

#loc("P-5.19")

Dicho de otro modo, se elige la secuencia que, filtrada por $p[n]$, queda más cerca de las observaciones. La búsqueda exhaustiva sobre las $M^L$ secuencias es inviable. La alternativa práctica y eficiente es el algoritmo de Viterbi.

=== Algoritmo de Viterbi

Los puntos clave para aplicar Viterbi son definir los estados, construir el diagrama de estados y obtener el *trellis* asociado. El trellis sirve para dos cosas: encontrar la secuencia transmitida más probable dadas las salidas y acotar la probabilidad de error de secuencia. #loc("P-5.20")

El estado en el instante $n$ lo componen los $K$ símbolos anteriores, y la salida sin ruido $o[n]$ queda determinada por el símbolo actual y el estado:

$ bold(psi)[n] = (A[n-1], A[n-2], dots, A[n-K])^T, quad o[n] = sum_(k=0)^K p[k] A[n-k] $ <eq-estado>

#loc("A-1.12")

La idea se apoya en esta propiedad: si el camino óptimo pasa por un nodo, ese camino es necesariamente el que minimiza la métrica acumulada hasta dicho nodo. Por eso, en cada etapa y para cada nodo se conserva solo el camino de menor métrica acumulada, llamado #term("superviviente")[Camino que llega a un nodo del trellis con la menor métrica acumulada; es el único que se conserva de todos los que llegan a ese nodo.]. Al llegar a la última etapa, el camino óptimo es el superviviente con menor métrica. #loc("P-5.25")

La métrica acumulada hasta la etapa $m$ se calcula de forma recursiva:

$ l_(0,m) = sum_(n=0)^m l_n, quad l_n = abs(q[n] - o[n])^2, quad l_(0,m) = l_(0,m-1) + l_m $ <eq-metrica>

#loc("A-1.14")

#fold(title: [Ejemplo 5.1: Viterbi para $p[n] = 0.5 delta[n] + delta[n-1]$], open: true)[
  Se transmite BPSK, $A[n] = plus.minus 1$, en AWGN. El canal tiene un coeficiente de memoria, luego el estado es $A[n-1]$ y la salida es $o[n] = 0.5 A[n] + A[n-1]$. #loc("P-5.22")

  #figure(
    table(
      columns: 4,
      table.header[Entrada $A[n]$][Estado $A[n-1]$][Siguiente estado][Salida $o[n]$],
      [$+1$], [$+1$], [$+1$], [$1.5$],
      [$+1$], [$-1$], [$+1$], [$-0.5$],
      [$-1$], [$+1$], [$-1$], [$0.5$],
      [$-1$], [$-1$], [$-1$], [$-1.5$],
    ),
    caption: [Salidas y transiciones del canal del ejemplo 5.1 (P-5.23).],
  ) <tab-ej51-salidas>

  Se reciben $q[n] = (-0.25, 0.5, -1, 1)$ para $n = 0, dots, 3$, con $A[n] = +1$ para $n < 0$ y $n >= 3$. Las métricas acumuladas en cada nodo (el superviviente se indica con el estado de procedencia) son:

  #figure(
    table(
      columns: 3,
      table.header[Etapa][Nodo $A[n] = +1$][Nodo $A[n] = -1$],
      [$n = 0$], [$3.0625$ (desde $+1$)], [$0.5625$ (desde $+1$)],
      [$n = 1$], [$1.5625$ (desde $-1$)], [$3.0625$ (desde $+1$)],
      [$n = 2$], [$3.3125$ (desde $-1$)], [$3.3125$ (desde $-1$)],
      [$n = 3$], [$3.5625$ (desde $+1$)], [descartado ($A[3] = +1$)],
    ),
    caption: [Métricas acumuladas del trellis del ejemplo 5.1 (cálculo propio, coherente con P-5.26).],
  ) <tab-ej51-metricas>

  Recorriendo el superviviente final hacia atrás se obtiene la secuencia más probable $(A[0], A[1], A[2], A[3]) = (+1, -1, +1, +1)$, con métrica $3.5625$.
]

=== Prestaciones del MLSD

Calcular la probabilidad de error exacta del MLSD es muy complicado, y las cotas habituales no son ajustadas. En la práctica se usa el procedimiento de *detección de eventos de error*: se toma una trayectoria óptima de referencia (por ejemplo, la que permanece siempre en el estado inicial). Un evento de error ocurre cuando se abandona temporalmente esa trayectoria y se vuelve a ella. Su probabilidad se aproxima por

$ P_"evento" approx Q(D_"min"/(2 sigma)) $ <eq-p-evento>

#loc("P-5.27")

donde $D_"min"$ es la distancia de la trayectoria de mínima distancia que llega al mismo estado final. Para la tasa de error de bit basta contar el número de bits $N_b$ en que difieren la trayectoria de referencia y el evento de error:

$ P_"MLSD" approx N_b Q(D_"min"/(2 sigma)) $ <eq-pmlsd>

#loc("P-5.28")

En general, la distancia mínima entre dos secuencias sin ruido, que se obtiene de forma práctica con un trellis de la secuencia de error, es:

$ D_"min"^2 = min_(A[n], A'[n]) sum_n abs(sum_(k=0)^K p[k] (A[n-k] - A'[n-k]))^2 $ <eq-dmin>

#loc("A-1.15")

La probabilidad de error del MLSD se escribe también como $kappa Q(D_"min"/(2 sigma))$, donde $kappa$ es el número máximo de secuencias a distancia $D_"min"$ de una secuencia recibida posible. #loc("A-1.14") La diapositiva P-5.28 ilustra el procedimiento con un trellis cuyas aristas indican distancias al cuadrado respecto a la trayectoria de referencia, con $D_"1-salto"^2 = 1 + 0.25$ y $D_"2-saltos"^2 = 1 + 2.25 + 0.25$.

En el ejemplo 5.1, un evento de error de un solo símbolo tiene secuencia de error $plus.minus 2$ y distancia al cuadrado $(0.5 dot 2)^2 + (1 dot 2)^2 = 5$. Los eventos más largos están más lejos (por ejemplo, $14$ para dos símbolos y $23$ para tres, cálculo propio). Por tanto $D_"min" = sqrt(5) approx 2.23$ y

$ P_e approx Q(sqrt(5)/(2 sigma)) $ <eq-pe-ej51>

#loc("P-5.29")

#callout(kind: "note", title: [COTA DEL FILTRO ADAPTADO])[En Barry se compara el MLSD con la cota del filtro adaptado, que corresponde a transmitir un único símbolo aislado (sin ISI). El MLSD nunca supera esa cota y en algunos canales la alcanza: la diferencia entre ambos mide la gravedad de la ISI. #loc("L-353")]

== Ecualización lineal

=== Arquitectura

La alternativa de menor coste es un filtro lineal $W(z)$ que actúa antes del decisor para deshacer el efecto del canal. #loc("P-5.31")

#flow(
  dir: "ltr",
  nd[$A[n]$],
  nd([$P(z)$], tone: "accent"),
  [$s[n]$],
  nd([Suma de ruido], sub: [$n[n]$]),
  [$q[n]$],
  nd([$W(z)$], tone: "accent"),
  [$u[n]$],
  nd([Decisor], tone: "dark"),
)

Definiendo el filtro equivalente $C(z) = P(z) W(z)$, la salida del ecualizador se descompone en señal deseada, ISI residual y ruido filtrado, para un retardo $d$ arbitrario (el de máximo $c[d]$):

$ C(z) = P(z) W(z) \
  u[n] = c[d] A[n-d] + sum_(m != d) c[m] A[n-m] + sum_m w[m] n[n-m] $ <eq-u-le>

#loc("P-5.32")

Al diseñar $W(z)$ se busca $c[d] approx 1$ con ISI residual y ruido filtrado lo más pequeños posible. Suponiendo $hat(A)[n] = A[n]$, el error de decisión $e[n] = u[n] - hat(A)[n]$ se separa en un término de ISI y otro de ruido:

$ E_S (z) = A(z) (P(z) W(z) - 1), quad E_N (z) = N(z) W(z) $ <eq-error-le>

#loc("P-5.34")

Como medida de calidad se usa la potencia del error de decisión $xi = EE[abs(e[n])^2]$ y no la probabilidad de error de bit, porque las fórmulas de BER suponen ruido blanco gaussiano y el ecualizador lo colorea. #loc("A-1.19")

Se estudian dos criterios: el sistema inverso o *zero forcing* (ZF) y el *error cuadrático medio mínimo* (MMSE). #loc("P-5.33")

=== Zero forcing

El ecualizador ZF invierte la respuesta del canal salvo un retardo, de modo que la ISI se anula. Se toma $d = 0$ sin pérdida de generalidad, porque un retardo puro no distorsiona la señal:

$ W_"ZF" (z) = z^(-d)/P(z) approx 1/P(z) $ <eq-wzf>

#loc("P-5.35")

Con este filtro, $u[n] = A[n] * p[n] * w[n] + n[n] * w[n] = A[n] + w[n] * n[n]$. La señal se recupera sin distorsión, pero el precio es no controlar el ruido: la única fuente de errores es el término de ruido coloreado, cuya densidad espectral es $sigma_n^2 abs(W(e^(j omega)))^2$ y que se amplifica donde $abs(P)$ es pequeño. Por el teorema de Parseval, la potencia de ruido en el decisor y la relación señal a ruido son:

$ sigma_(U_n)^2 &= sigma_n^2 1/(2 pi) integral_(-pi)^pi abs(W(e^(j omega)))^2 dif omega = sigma_n^2 sum_n abs(w[n])^2 \
  "SNR"_"LE-ZF" &= sigma_A^2/sigma_(U_n)^2 = sigma_A^2/sigma_n^2 [1/(2 pi) integral_(-pi)^pi abs(W(e^(j omega)))^2 dif omega]^(-1) $ <eq-snr-zf>

#loc("P-5.36", plural: true)

Como en ZF la componente de señal del error es nula, la potencia del error de decisión es solo la del ruido filtrado:

$ xi_"LE-ZF" = EE[abs(e[n])^2] = sigma_n^2/(2 pi) integral_(-pi)^pi abs(W(e^(j omega)))^2 dif omega = sigma_n^2/(2 pi) integral_(-pi)^pi 1/abs(P(e^(j omega)))^2 dif omega $ <eq-xi-zf>

#loc("P-5.37")

#callout(kind: "warning", title: [REQUISITOS])[La integral es finita solo si $P$ no se anula sobre la circunferencia unidad. Además, $1/P(z)$ puede ser no causal o inestable. En particular, si $P$ tiene un cero en la circunferencia unidad, el inverso es inestable (se trata en el complemento sobre el DFE). #loc("A-1.26")]

=== MMSE: principio de ortogonalidad

El criterio MMSE no pretende invertir el canal, sino minimizar directamente la potencia de la secuencia de error. Intuitivamente, admite cierta ISI residual a cambio de no amplificar el ruido. El análisis formal sigue tres pasos: equivalencia entre MMSE y principio de ortogonalidad, obtención del filtro de Wiener IIR a partir de él, y aplicación a la ecualización lineal. #loc("P-5.38")

Sea $u[n] = sum_j w[j] q[n-j]$ la salida del filtro y $e[n] = u[n] - A[n]$. Los coeficientes $w[j]$ minimizan $EE[abs(e[n])^2]$ si y solo si el error es ortogonal a la entrada del filtro:

$ min_(w[n]) EE[abs(e[n])^2] <==> EE[e[n] q^*[n-i]] = 0, quad -oo < i < oo $ <eq-ortog>

#loc("P-5.39")

Para la demostración en el caso real, como $e[n] = sum_j w[j] q[n-j] - A[n]$, se deriva respecto a cada coeficiente. El coste es cuadrático y convexo en $w$, de modo que anular el gradiente es condición necesaria y suficiente de mínimo:

$ partial/(partial w[j]) EE[e[n]^2] &= 2 EE[e[n] (partial e[n])/(partial w[j])] \
  &= 2 EE[e[n] q[n-j]] = 0, quad -oo < j < oo $ <eq-deriv-ortog>

#loc("P-5.40")

El caso complejo se demuestra derivando respecto a la parte real e imaginaria de cada coeficiente. #loc("A-1.50")

=== MMSE: filtro de Wiener IIR

Sustituyendo la expresión de $e[n]$ en la condición de ortogonalidad se obtiene una ecuación de convolución entre el filtro y la autocorrelación de $q[n]$:

$ EE[A[n] q^*[n-i]] &= sum_(j=-oo)^oo w[j] EE[q[n-j] q^*[n-i]] \
  R_(A q)[i] &= sum_(j=-oo)^oo w[j] R_q [i-j] = (w * R_q)[i], quad -oo < i < oo $ <eq-wh-iir>

#loc("P-5.42", plural: true)

Pasando al dominio $Z$ ($S_(A q)(z)$ y $S_q (z)$ son las transformadas de $R_(A q)$ y $R_q$) la condición se convierte en el filtro de Wiener IIR:

$ S_(A q)(z) = W(z) S_q (z) <==> W_"IIR" (z) = S_(A q)(z)/S_q (z) $ <eq-wiener-iir>

#loc("P-5.44")

=== MMSE: ecualizador lineal

Para particularizar el filtro de Wiener hay que calcular $R_(A q)$ y $R_q$. Como señal y ruido son procesos de media nula e independientes, $R_(A q_n)[m] = EE[A[n+m]] EE[q_n^*[n]] = 0$, y por las relaciones de la @eq-cruzadas[] y la @eq-salida[]:

$ R_(A q)[m] = R_A [m] * p^*[-m], quad R_q [m] = R_A [m] * p[m] * p^*[-m] + R_n [m] $ <eq-corr-mmse>

#loc("P-5.46")

Tomando transformadas $Z$ se obtiene el ecualizador lineal MMSE y su respuesta en frecuencia:

$ W_"LE-MMSE" (z) &= (S_A (z) P^*(1/z^*))/(S_A (z) P(z) P^*(1/z^*) + S_n (z)) \
  W_"LE-MMSE" (e^(j omega)) &= (S_A (e^(j omega)) P^*(e^(j omega)))/(S_A (e^(j omega)) abs(P(e^(j omega)))^2 + S_n (e^(j omega))) = (P^*(e^(j omega)))/(abs(P(e^(j omega)))^2 + 1/"SNR") $ <eq-wmmse>

#loc("P-5.47")

Con señal y ruido blancos, $1/"SNR" = sigma_n^2 / sigma_A^2$ y el ecualizador queda $W_"LE-MMSE" (z) = sigma_A^2 P^*(1/z^*) / (sigma_A^2 P(z) P^*(1/z^*) + sigma_n^2)$.

=== MMSE: potencia del error

Por la ortogonalidad, $xi_"LE-MMSE" = EE[abs(e[n])^2] = EE[e[n] A^*[n]]$, ya que el término $sum_j w^*[j] EE[e[n] q^*[n-j]]$ se anula. Desarrollando el resto con $R_(A q)[j] = sigma_A^2 p^*[-j]$:

$ xi_"LE-MMSE" &= EE[abs(A[n])^2] - sum_(j=-oo)^oo w[j] R_(A q)^*[j] \
  &= sigma_A^2 - sigma_A^2 sum_(j=-oo)^oo w[j] p[-j] = sigma_A^2 (1 - (w * p)[0]) $ <eq-xi-mmse-t>

#loc("P-5.48", plural: true)

En frecuencia, $(w * p)[0] = 1/(2 pi) integral W(e^(j omega)) P(e^(j omega)) dif omega$. Introduciendo la @eq-wmmse[], el integrando $1 - W P$ vale $sigma_n^2 / (sigma_A^2 abs(P)^2 + sigma_n^2)$ y resulta:

$ xi_"LE-MMSE" = sigma_A^2/(2 pi) integral_(-pi)^pi [1 - W(e^(j omega)) P(e^(j omega))] dif omega = sigma_n^2/(2 pi) integral_(-pi)^pi sigma_A^2/(sigma_A^2 abs(P(e^(j omega)))^2 + sigma_n^2) dif omega $ <eq-xi-mmse>

#loc("P-5.49")

=== Comparación ZF y MMSE

Los resultados del ecualizador lineal se resumen en @tab-le.

#figure(
  table(
    columns: 3,
    table.header[Algoritmo][Ecualizador][Potencia del error $xi = EE[abs(e[n])^2]$],
    [LE-ZF], [$W(z) = 1/P(z)$], [$sigma_n^2/(2 pi) integral_(-pi)^pi 1/abs(P(e^(j omega)))^2 dif omega$],
    [LE-MMSE],
    [$W(z) = (sigma_A^2 P^*(1/z^*))/(sigma_A^2 P(z) P^*(1/z^*) + sigma_n^2)$],
    [$sigma_A^2/(2 pi) integral_(-pi)^pi sigma_n^2/(sigma_A^2 abs(P(e^(j omega)))^2 + sigma_n^2) dif omega$],
  ),
  caption: [Ecualizadores lineales ZF y MMSE (P-5.50).],
) <tab-le>

Ambas potencias de error se pueden escribir de forma muy parecida:

$ xi_"LE-ZF" = sigma_n^2/(2 pi) integral_(-pi)^pi 1/abs(P(e^(j omega)))^2 dif omega, quad
  xi_"LE-MMSE" = sigma_n^2/(2 pi) integral_(-pi)^pi 1/(abs(P(e^(j omega)))^2 + sigma_n^2 \/ sigma_A^2) dif omega $ <eq-comparacion>

#loc("P-5.51")

Como $sigma_n^2 / sigma_A^2 > 0$, el integrando MMSE es estrictamente menor que el del ZF en cada frecuencia, y por tanto $xi_"LE-MMSE" < xi_"LE-ZF"$. Además, hay dos comportamientos límite (si $P$ no se anula en la circunferencia unidad):

- Con ruido muy pequeño, el MMSE tiende al ZF: $lim_(sigma_n^2 -> 0) xi_"LE-MMSE" = xi_"LE-ZF"$.
- Con ruido muy grande, el MMSE tiende al filtro adaptado: $W(e^(j omega)) approx sigma_A^2 / sigma_n^2 P^*(e^(j omega))$ cuando $sigma_n^2 >> sigma_A^2$.

#loc("P-5.51", plural: true)

#fold(title: [Ilustraciones de las diapositivas P-5.52 a P-5.55])[
  - *Respuesta temporal del ecualizador* (P-5.52): el ZF y el MMSE son distintos, y el MMSE no implementa el filtro inverso.
  - *Canal más ecualizador* (P-5.53): con ZF la respuesta global es un impulso; con MMSE queda ISI residual a cambio de menos ruido.
  - *Respuestas en frecuencia* (P-5.54): se comparan el sistema directo, el ZF y el MMSE con $"SNR" = 8$ dB y $20$ dB; el MMSE se parece más al ZF cuanto mayor es la SNR.
  - *Potencia de error* (P-5.55): ambos criterios convergen al crecer la SNR, y el MMSE da mejores prestaciones a SNR baja.
]

=== Ejemplo 5.2: ZF y MMSE con un canal FIR

#fold(title: [Canal $p[n] = 0.25 delta[n] + delta[n-1] - 0.25 delta[n-2]$ con BPSK y $sigma_n^2 = 0.1$], open: true)[
  Se pide el ecualizador y la potencia de error con una estructura lineal, para ZF y MMSE. Como ayuda, para $a > abs(b)$ y $n$ entero se cumple $integral_(-pi)^pi dif omega / (a + b cos(n omega)) = 2 pi / sqrt(a^2 - b^2)$. #loc("P-5.56")

  La transformada de Fourier de la respuesta al impulso y su módulo al cuadrado son:

  $ P(e^(j omega)) &= 0.25 + e^(-j omega) - 0.25 e^(-j 2 omega) \
    abs(P(e^(j omega)))^2 &= P(e^(j omega)) P^*(e^(j omega)) = 1.125 - 0.125 cos(2 omega) $ <eq-ej52-p>

  #loc("P-5.57")

  *ZF.* Sustituyendo en la @eq-xi-zf[] se obtiene el error, y el ecualizador es el inverso del canal:

  $ xi_"LE-ZF" = sigma_n^2/(2 pi) integral_(-pi)^pi dif omega/(1.125 - 0.125 cos(2 omega)) = sigma_n^2/sqrt(1.125^2 - 0.125^2) = 0.0894 \
    W_"ZF" (z) = 1/P(z) = 1/(0.25 + z^(-1) - 0.25 z^(-2)) $ <eq-ej52-zf>

  #loc("P-5.58")

  *MMSE.* Con $sigma_A^2 = 1$ para BPSK, la @eq-xi-mmse[] da un error menor, como cabe esperar:

  $ xi_"LE-MMSE" &= sigma_n^2/(2 pi) integral_(-pi)^pi dif omega/(1.125 + 0.1 - 0.125 cos(2 omega)) = 0.0821 \
    W_"MMSE" (z) &= (0.25 + z - 0.25 z^2)/((0.25 + z^(-1) - 0.25 z^(-2))(0.25 + z - 0.25 z^2) + sigma_n^2) $ <eq-ej52-mmse>

  #loc("P-5.59")
]

=== Ejemplo 5.3: ecualizador MMSE mediante funciones racionales

#fold(title: [Canal $P(z) = sqrt(1 - 0.8^2)/(1 - 0.8 z^(-1))$ con $sigma_A^2 = 2$ y $sigma_n^2 = 2$])[
  Símbolos y ruido son independientes y blancos. Se calculan $S_(A q)(z)$, $S_q (z)$ y $W(z) = S_(A q)(z) / S_q (z)$. Se usa que $a^(abs(m)) <-> (1 - a^2)/((1 - a z^(-1))(1 - a z))$ para $abs(a) < 1$. #loc("P-5.60", plural: true)

  *Correlación cruzada.* Como el ruido y los símbolos son independientes, $R_(A q)[m] = R_A [m] * p[-m]$, y con $P$ real:

  $ S_(A q)(z) = S_A (z) P^*(1/z^*) = 2 sqrt(1 - 0.8^2)/(1 - 0.8 z) = 1.2/(1 - 0.8 z) $ <eq-ej53-saq>

  #loc("P-5.62", plural: true)

  *Autocorrelación.* Primero $S_s (z) = S_A (z) P(z) P^*(1/z^*) = 2 (1 - 0.8^2)/((1 - 0.8 z^(-1))(1 - 0.8 z))$, que corresponde a $R_s [m] = 2 (0.8)^(abs(m))$. Sumando el ruido:

  $ S_q (z) &= S_s (z) + S_n (z) = (2 (1 - 0.8^2) + 2 (1 - 0.8 z^(-1))(1 - 0.8 z))/((1 - 0.8 z^(-1))(1 - 0.8 z)) = N(z)/D(z) \
    N(z) &= 4 - 1.6 (z + z^(-1)) = 3.2 (1 - 0.5 z^(-1))(1 - 0.5 z) \
    S_q (z) &= 3.2 ((1 - 0.5 z^(-1))(1 - 0.5 z))/((1 - 0.8 z^(-1))(1 - 0.8 z)) $ <eq-ej53-sq>

  #loc("P-5.63", plural: true)

  *Ecualizador.* Dividiendo:

  $ W(z) = S_(A q)(z) S_q^(-1) (z) = 1.2/(1 - 0.8 z) dot 1/3.2 dot ((1 - 0.8 z^(-1))(1 - 0.8 z))/((1 - 0.5 z^(-1))(1 - 0.5 z)) = (0.375 (1 - 0.8 z^(-1)))/((1 - 0.5 z^(-1))(1 - 0.5 z)) $ <eq-ej53-w>

  #loc("P-5.66")
]

== Ecualización lineal adaptativa. Filtros FIR y MMSE

=== Esquema adaptativo

Los ecualizadores anteriores son muy relevantes en teoría, pero poco prácticos: al iniciar una comunicación el canal no se conoce. Se puede estimar el canal y diseñar el ecualizador a partir de él, o calcular el ecualizador directamente. Lo más habitual es enviar una *secuencia de entrenamiento* y hacer el proceso iterativo, de modo que el ecualizador se aproxime progresivamente al comportamiento óptimo. Se prefiere el criterio MMSE, para evitar el aumento de ruido, y filtros FIR, para evitar la inestabilidad de un IIR que se ajusta sobre la marcha. #loc("A-1.41") Un interruptor distingue dos fases: en la posición 1 (entrenamiento) el error se calcula con la secuencia conocida, y en la posición 2 se usan las decisiones del receptor, lo que permite seguir canales variables. Aquí se estudia solo la fase de entrenamiento con canal estático. #loc("P-5.68")

#flow(
  dir: "ltr",
  nd[$A[n]$],
  nd([$P(z)$], tone: "accent"),
  [$s[n]$],
  nd([Suma de ruido], sub: [$n[n]$]),
  [$q[n]$],
  nd([$W(z)$ FIR], sub: [$N$ coeficientes], tone: "accent"),
  [$u[n]$],
  nd([Decisor], tone: "dark"),
)

La formulación es general para muchas aplicaciones y la ecualización es solo una de ellas: $q[n]$ es la secuencia recibida, $d[n]$ la señal de referencia (aquí la secuencia de entrenamiento) y $u[n]$ la salida de un filtro FIR de $N$ coeficientes. #loc("P-5.69")

=== Formulación vectorial

La gran ventaja del filtro FIR es que la salida es combinación lineal de las muestras de entrada, y la convolución se interpreta como un producto escalar. Con el vector de coeficientes $bold(w)$ y el vector de entrada $bold(q)[n]$:

$ bold(w) = (w[0], w[1], dots, w[N-1])^T, quad bold(q)[n] = (q[n], q[n-1], dots, q[n-N+1])^T \
  u[n] = sum_(k=0)^(N-1) w^*[k] q[n-k] = bold(w)^H bold(q)[n] $ <eq-fir-vec>

#loc("P-5.71")

#hint[Convención: la diapositiva P-5.71 escribe $bold(w)^T bold(q)[n]$ y las siguientes usan $bold(w)^H bold(q)[n]$. Aquí se emplea la forma con conjugado de los apuntes (A-1.43), que coincide con la de las diapositivas para coeficientes reales.]

=== Filtro de Wiener FIR

El resultado es el filtro de Wiener FIR, que minimiza el error cuadrático medio dentro de la clase de filtros de $N$ coeficientes:

$ bold(w)_"opt" = bold(R)^(-1) bold(p), quad bold(R) = EE[bold(q)[n] bold(q)^H [n]], quad bold(p) = EE[bold(q)[n] d^*[n]] $ <eq-wiener-fir>

#loc("P-5.76")

La demostración es análoga a la del caso IIR. Con el error $e[n] = d[n] - bold(w)^H bold(q)[n]$ y $d[n] = A[n]$, minimizar el MSE equivale al principio de ortogonalidad, ahora solo para los $N$ retardos del filtro, $EE[e[n] q^*[n-i]] = 0$ para $0 <= i <= N-1$. #loc("P-5.73") En forma vectorial:

$ EE[bold(q)[n] e^*[n]] = EE[bold(q)[n] d^*[n]] - EE[bold(q)[n] bold(q)^H [n]] bold(w) = bold(p) - bold(R) bold(w) = bold(0) $ <eq-normal>

#loc("A-1.43")

Para datos reales, las $N$ ecuaciones se escriben $R_(A q)[i] = sum_(k=0)^(N-1) w[k] R_q [i-k]$, es decir, $bold(p)_(A q) = bold(R)_q bold(w)$. #loc("P-5.74") La matriz $bold(R)$ es de tipo Toeplitz (elementos idénticos en cada diagonal) y hermítica. Además es definida positiva: como el ruido es blanco, $bold(R)$ es la matriz de autocorrelación de la señal más $sigma_n^2 bold(I)$ con $sigma_n^2 > 0$, y por eso es invertible. En la notación de los apuntes, con $r[i] = EE[q[n+i] q^*[n]]$:

$ bold(R) = mat(r[0], r[1], dots.c, r[N-1]; r^*[1], r[0], dots.c, r[N-2]; dots.v, dots.v, dots.down, dots.v; r^*[N-1], r^*[N-2], dots.c, r[0]) $ <eq-R-toeplitz>

#loc("P-5.75")

El error mínimo se obtiene sustituyendo $bold(w)_"opt"$:

$ xi_"min" = EE[abs(e[n])^2]_(bold(w) = bold(w)_"opt") = EE[abs(d[n])^2] - bold(p)^H bold(w)_"opt" $ <eq-ximin-fir>

#loc("P-5.78")

La solución es sencilla, pero exige conocer los estadísticos de segundo orden e invertir una matriz. Ambas cosas son delicadas cuando el canal varía con el tiempo. Los dos apartados siguientes relajan primero la inversión y después el conocimiento de los estadísticos.

=== Solución iterativa: descenso por gradiente

El error cuadrático medio en función de los coeficientes se denomina *superficie de error*. Desarrollando $xi(bold(w)) = EE[abs(d[n] - bold(w)^H bold(q)[n])^2]$ y completando cuadrados con $bold(p) = bold(R) bold(w)_"opt"$:

$ xi(bold(w)) &= sigma_d^2 + bold(w)^H bold(R) bold(w) - 2 Re(bold(p)^H bold(w)) \
  &= xi_"min" + (bold(w) - bold(w)_"opt")^H bold(R) (bold(w) - bold(w)_"opt") $ <eq-superficie>

#loc("P-5.77", plural: true)

Como $bold(R)$ es definida positiva, esta función cuadrática es un hiperparaboloide con un único mínimo, que coincide con $bold(w)_"opt" = bold(R)^(-1) bold(p)$. #loc("P-5.79") El algoritmo de descenso por gradiente (*steepest descent*) se acerca progresivamente a ese mínimo, desplazando los coeficientes en sentido opuesto al gradiente. El paso de adaptación $mu$ condiciona la velocidad de convergencia. Con $nabla_(bold(w)^H) xi[n] = bold(R) (bold(w)[n] - bold(w)_"opt")$:

$ bold(w)[n+1] &= bold(w)[n] + mu (-nabla_(bold(w)^H) xi[n]) = bold(w)[n] - mu bold(R) (bold(w)[n] - bold(R)^(-1) bold(p)) \
  &= (bold(I) - mu bold(R)) bold(w)[n] + mu bold(p) $ <eq-sd>

#loc("P-5.81", plural: true)

El procedimiento (P-5.83) es: partir de un $bold(w)[0]$ arbitrario, calcular el gradiente en ese punto, desplazar los coeficientes proporcionalmente y en sentido opuesto, y repetir. Se evita invertir $bold(R)$, aunque todavía hace falta conocer $bold(R)$ y $bold(p)$.

#callout(kind: "info", title: [CONDICIÓN DE CONVERGENCIA])[El algoritmo converge para cualquier $bold(w)[0]$ si y solo si
$ 0 < mu < 2/lambda_"max" $ <eq-mu-conv>
donde $lambda_"max"$ es el mayor autovalor de $bold(R)$. #loc("A-1.46")

Demostración [A-1.52]. Con $bold(v)[n] = bold(w)[n] - bold(w)_"opt"$ se cumple $bold(v)[n+1] = (bold(I) - mu bold(R)) bold(v)[n]$. Con la descomposición $bold(R) = bold(Q) bold(Lambda) bold(Q)^H$ y el giro $bold(v)'[n] = bold(Q)^H bold(v)[n]$, el sistema se desacopla:

$ bold(v)'[n] = (bold(I) - mu bold(Lambda))^n bold(v)'[0] $

que tiende a cero para todo $bold(v)'[0]$ si y solo si $abs(1 - mu lambda_i) < 1$ para todo $i$. Como los autovalores son positivos y $mu > 0$, esto equivale a $mu < 2 / lambda_"max"$.]

=== Solución adaptativa: algoritmo LMS

El punto más cuestionable del descenso por gradiente es que sigue necesitando los estadísticos. Los algoritmos de gradiente estocástico operan con un estimador del gradiente. El más sencillo, el *LMS* (Least Mean Square), aproxima los estadísticos por sus valores instantáneos:

$ bold(R) = EE[bold(q)[n] bold(q)^H [n]] approx bold(q)[n] bold(q)^H [n], quad bold(p) = EE[bold(q)[n] d^*[n]] approx bold(q)[n] d^*[n] $ <eq-lms-aprox>

#loc("P-5.84")

Sustituyendo en la @eq-sd[], con $e[n] = d[n] - bold(w)^H [n] bold(q)[n]$:

$ bold(w)[n+1] &= (bold(I) - mu bold(q)[n] bold(q)^H [n]) bold(w)[n] + mu bold(q)[n] d^*[n] \
  &= bold(w)[n] + mu bold(q)[n] (d^*[n] - bold(q)^H [n] bold(w)[n]) \
  &= bold(w)[n] + mu e^*[n] bold(q)[n] $ <eq-lms>

#loc("P-5.85")

Su comportamiento es una versión ruidosa del descenso por gradiente (incorpora el ruido de estimar los estadísticos), y los apuntes lo consideran análogo a él en cuanto a evolución en media de las trayectorias y condiciones de convergencia. #loc("A-1.46") La evolución se visualiza con dos gráficas: la *curva de aprendizaje* (evolución temporal de la potencia del error, P-5.86) y la *superficie de error* en curvas de nivel con la trayectoria de los coeficientes encima (P-5.87).

=== Ejemplo 5.4: Wiener y descenso por gradiente

#fold(title: [Canal $P(z) = 1/(1 - 0.5 z^(-1))$, BPSK de potencia unidad, $sigma_n^2 = 1/4$ y ecualizador de dos coeficientes])[
  Se pide la solución de Wiener, la ecuación del descenso por gradiente y la solución sin ruido. Se usan $a^(abs(n)) <-> (1 - a^2)/((1 - a z^(-1))(1 - a z))$ y $a^n u[n] <-> 1/(1 - a z^(-1))$. #loc("P-5.88")

  Con señal y ruido independientes, $R_q [m] = R_s [m] + R_n [m]$ y $R_(A q)[m] = R_(A s)[m]$. #loc("P-5.90", plural: true) Como $S_s (z) = sigma_A^2 / ((1 - 0.5 z^(-1))(1 - 0.5 z))$:

  $ R_s [m] = 1/(1 - 0.5^2) 0.5^(abs(m)) = 4/3 0.5^(abs(m)), quad bold(R) = mat(4/3 + 1/4, 4/6; 4/6, 4/3 + 1/4), quad bold(R)^(-1) = mat(0.7677, -0.3232; -0.3232, 0.7677) $ <eq-ej54-R>

  #loc("P-5.92", plural: true)

  La correlación cruzada es $R_(A q)[m] = p[-m] = 0.5^(-m) u[-m]$, luego $bold(p) = (1, 0)^T$. La solución de Wiener y la ecuación del descenso por gradiente son:

  $ bold(w)_"opt" = bold(R)^(-1) bold(p) = mat(0.7677; -0.3232), quad bold(w)[n+1] = (bold(I) - mu bold(R)) bold(w)[n] + mu bold(p) $ <eq-ej54-w>

  #loc("P-5.94")

  Los autovalores de $bold(R)$ son $9/4$ y $11/12$ (cálculo propio), de modo que, por la @eq-mu-conv[], el descenso por gradiente converge si $0 < mu < 8/9$. El error mínimo es $xi_"min" = 1 - bold(p)^T bold(w)_"opt" = 0.2323$ (cálculo propio, con la @eq-ximin-fir[]).

  *Sin ruido.* Ahora $bold(R) = mat(4/3, 4/6; 4/6, 4/3)$, cuya inversa es $mat(1, -0.5; -0.5, 1)$, y

  $ bold(w)_"opt" = bold(R)^(-1) bold(p) = mat(1; -0.5) $ <eq-ej54-sinruido>

  #loc("P-5.95", plural: true)

  Es el filtro inverso del canal: $W(z) = 1 - 0.5 z^(-1)$ y $P(z) W(z) = 1$. El inverso de $P(z)$ es un FIR de longitud 2, que es justo la familia en la que se busca, de modo que el MMSE FIR coincide con el ZF. #loc("P-5.96")
]

== Ejercicio final

El ejercicio 5.5 (P-5.97 a P-5.105) reúne el cálculo de la solución de Wiener FIR con varios usuarios. Dos usuarios transmiten secuencias BPSK independientes de potencia unidad, con ruido blanco de potencia $sigma_n^2$, por dos canales discretos equivalentes $p_1 [n] = delta[n] + a delta[n-1]$ y $p_2 [n] = delta[n] + a delta[n+1]$, con $a$ una constante arbitraria. Cada receptor es un ecualizador FIR de $N = 2$ coeficientes con criterio MMSE. Se pide la solución de Wiener cuando solo está activo cada usuario y cuando transmiten a la vez. No hace falta invertir la matriz, pero sí identificar cada componente. #loc("P-5.98")

=== Un solo usuario activo

La autocorrelación de $q[n]$ se obtiene con la densidad espectral de la señal filtrada. Con el usuario 1:

$ S_(y_1)(z) = sigma_A^2 P_1 (z) P_1^*(1/z^*) = (1 + a z^(-1))(1 + a z) = 1 + a^2 + a z^(-1) + a z $ <eq-ej55-sy>

#loc("P-5.100")

y por tanto $R_(y_1)[m] = a delta[m-1] + (1 + a^2) delta[m] + a delta[m+1]$. Para el usuario 2 se obtiene exactamente la misma $S_(y_2)(z)$. #loc("P-5.102") Con $R_q [m] = R_(y_i)[m] + sigma_n^2 delta[m]$, la matriz de autocorrelación es igual en ambos casos:

$ bold(R) = mat(1 + a^2 + sigma_n^2, a; a, 1 + a^2 + sigma_n^2) $ <eq-ej55-R>

#loc("P-5.101")

Las correlaciones cruzadas son $R_(A_1 q)[m] = p_1 [-m] = delta[m] + a delta[m+1]$ y $R_(A_2 q)[m] = p_2 [-m] = delta[m] + a delta[m-1]$, con vectores:

$ bold(p)_1 = mat(1; 0), quad bold(p)_2 = mat(1; a) $ <eq-ej55-p>

#loc("P-5.101", plural: true)

y las soluciones de Wiener son $bold(w)_1^"opt" = bold(R)^(-1) bold(p)_1$ y $bold(w)_2^"opt" = bold(R)^(-1) bold(p)_2$. #loc("P-5.103") Invirtiendo con $alpha = 1 + a^2 + sigma_n^2$ (cálculo propio): $bold(w)_1^"opt" = 1/(alpha^2 - a^2) (alpha, -a)^T$ y $bold(w)_2^"opt" = 1/(alpha^2 - a^2) (alpha - a^2, a (alpha - 1))^T$.

=== Los dos usuarios a la vez

Ahora $q[n] = y_1 [n] + y_2 [n] + n[n]$, con $R_q [m] = R_(y_1)[m] + R_(y_2)[m] + R_n [m]$, y el ruido solo aparece una vez:

$ bold(R) = mat(2 (1 + a^2) + sigma_n^2, 2 a; 2 a, 2 (1 + a^2) + sigma_n^2) $ <eq-ej55-R2>

#loc("P-5.104")

Las correlaciones cruzadas no cambian respecto a los casos individuales, por lo que

$ bold(w)_1^"opt" = bold(R)^(-1) mat(1; 0), quad bold(w)_2^"opt" = bold(R)^(-1) mat(1; a) $ <eq-ej55-w>

#loc("P-5.105")

con la nueva $bold(R)$, que incluye la interferencia del otro usuario. Por eso cada ecualizador cambia respecto al caso de un solo usuario. #loc("A-1.70")

== Complemento: ecualizador con realimentación de decisiones (DFE)

#callout(kind: "note", title: [FUERA DE LAS DIAPOSITIVAS])[Esta sección procede de los apuntes (A-1.26 a A-1.40) y no aparece en las presentaciones. El temario sí incluye las arquitecturas realimentadas (DFE).]

=== Motivación y estructura

El ecualizador lineal ZF puede ser inestable si hay un polo en la circunferencia unidad. El DFE es robusto frente a esa situación y, además, suele reducir el efecto del ruido. La ISI se descompone en una parte precursora (producida por símbolos futuros) y otra postcursora (por los símbolos pasados), con el retardo ajustado para que la muestra mayor de $p[n]$ esté en el origen. Los símbolos pasados ya se han decidido, y en la parte postcursora se sustituyen por sus decisiones:

$ q[k] = p[0] A[k] + sum_(j<0) p[j] A[k-j] + sum_(j>0) p[j] hat(A)[k-j] + n[k] $ <eq-dfe-q>

#loc("A-1.26")

El DFE usa dos filtros: uno *directo* $W_2 (z)$ (precursor), que debe ser causal, estable y mónico, y uno de *realimentación* $B(z)$ (postcursor), también causal y mónico. Si la decisión es correcta, su efecto se cancela restando, sin añadir ruido y sin invertir funciones de transferencia. Si la decisión es errónea, se cancela de forma errónea, la ISI aumenta y se produce propagación de errores. #loc("A-1.27") Por eso, para el análisis se suele suponer $hat(A)[k-j] = A[k-j]$ (sin propagación de errores).

#callout(kind: "note", title: [SESGO DEL MMSE-DFE])[El filtro MMSE hace que la muestra a la entrada del decisor contenga una componente proporcional al símbolo actual, con amplitud reducida. Escalar la entrada del decisor para eliminar ese sesgo da el MMSE-DFE insesgado, con menor probabilidad de error aunque con mayor MSE. #loc("L-383")]

=== Filtro directo y filtro de realimentación

El filtro directo del DFE es el del caso lineal multiplicado por $B(z)$. Para ZF es inmediato, porque se impone que no haya ISI; para MMSE se obtiene aplicando de nuevo el principio de ortogonalidad:

$ W_2 (z) = B(z) W_1 (z), quad "con" W_1 (z) = 1/P(z) "(ZF)" "y" W_1 (z) = S_(A q)(z)/S_q (z) "(MMSE)" $ <eq-w2-b>

#loc("A-1.28", plural: true)

El filtro $B(z)$ blanquea el error. Para calcularlo se factoriza espectralmente la densidad $S_e (z)$ del error:

$ S(z) = gamma^2 M(z) M^*(1/z^*), quad gamma^2 = exp(1/(2 pi) integral_(-pi)^pi ln S(e^(j omega)) dif omega) $ <eq-fact-espectral>

#loc("A-1.33")

donde $M(z)$ es mónica, causal y estable (fase mínima), y $M^*(1/z^*)$ es su recíproca (fase máxima). El blanqueador es $B(z) = M_e^(-1)(z)$ y la potencia de error resultante es $gamma_e^2$. #loc("A-1.36") En la práctica, si se factoriza el canal como $P(z) = P_0 P_"min" (z) P_"max" (z)$ y se define $S_r (z) = gamma_r^2 M_r (z) M_r^*(1/z^*)$, resulta lo siguiente:

- *DFE-ZF*: $S_r (z) = P(z) P^*(1/z^*)$, con $B(z) = M_r (z) = P_"min" (z) P_"max"^* (1/z^*)$ y $xi_"DFE-ZF" = sigma_n^2 / gamma_r^2$.
- *DFE-MMSE*: $S_r (z) = S_A (z) P(z) P^*(1/z^*) + S_n (z)$, con $B(z) = M_r (z)$ y $xi_"DFE-MMSE" = sigma_n^2 sigma_A^2 / gamma_r^2$.

#loc("A-1.37", plural: true)

=== Resumen de arquitecturas y ejemplo

Los ecualizadores y la potencia de error de las cuatro arquitecturas se reúnen en @tab-resumen, con $P(z) = P_0 P_"min" (z) P_"max" (z)$.

#figure(
  table(
    columns: 3,
    table.header[Algoritmo][Ecualizador][Potencia del error $xi$],
    [LE-ZF], [$W(z) = 1/P(z)$], [$sigma_n^2/(2 pi) integral 1/abs(P)^2 dif omega$],
    [LE-MMSE], [$W(z) = (sigma_A^2 P^*(1/z^*))/(sigma_A^2 P P^*(1/z^*) + sigma_n^2)$], [$sigma_A^2/(2 pi) integral sigma_n^2/(sigma_A^2 abs(P)^2 + sigma_n^2) dif omega$],
    [DFE-ZF], [$B(z) = M_r (z)$, $W_2 (z) = (P_"max"^*(1/z^*))/(P_0 P_"max" (z))$], [$sigma_n^2 / gamma_r^2$],
    [DFE-MMSE], [$B(z) = M_r (z)$, $W_2 (z) = (sigma_A^2 P^*(1/z^*) M_r (z))/(sigma_A^2 P P^*(1/z^*) + sigma_n^2)$], [$sigma_n^2 sigma_A^2 / gamma_r^2$],
  ),
  caption: [Arquitecturas de ecualización y potencia del error de decisión (A-1.40).],
) <tab-resumen>

Para el canal del ejemplo 5.2 ($p[n] = 0.25 delta[n] + delta[n-1] - 0.25 delta[n-2]$, BPSK y $sigma_n^2 = 0.1$), el ejemplo 1.5 de los apuntes obtiene $xi_"DFE-ZF" approx 0.0892$ y $xi_"DFE-MMSE" approx 0.0818$ (frente a $0.0894$ y $0.0821$ del ecualizador lineal en el ejemplo 5.2). El DFE mejora ligeramente al LE con ambos criterios. #loc("A-1.39") El caso MMSE sigue siendo mejor que el ZF, como en el ecualizador lineal.
