// Figuras del Tema 4 de Microondas (Redes de Microondas).
// Se importan desde la entrada y se llama a cada función donde deba aparecer.
#import "/utils/cetz.typ" as cetz
#import "/utils/figure.typ": arrow, c, tag, txt

// ---------------------------------------------------------------------
// Utilidades comunes
// ---------------------------------------------------------------------

#let mt(body, ..args) = txt(body, fill: c.ink, ..args)
#let plano = (paint: c.grey2, thickness: .6pt, dash: "dashed")
#let hilo = .8pt + c.ink

// Terminal abierto de una línea.
#let borne(p) = {
  import cetz.draw: *
  circle(p, radius: 2.4, fill: white, stroke: hilo)
}

// Caja rectangular con una etiqueta centrada.
#let caja(p0, p1, body, relleno: c.blue1, size: 9pt) = {
  import cetz.draw: *
  rect(p0, p1, fill: relleno, stroke: hilo, radius: 3)
  content(((p0.at(0) + p1.at(0)) / 2, (p0.at(1) + p1.at(1)) / 2), mt(size: size)[#body])
}

// Flecha que representa una onda, con su etiqueta encima.
#let onda(a, b, etiqueta, tono) = {
  import cetz.draw: *
  arrow(a, b, color: tono, w: 1pt)
  content(((a.at(0) + b.at(0)) / 2, a.at(1) + 5), mt(size: 8pt)[#etiqueta], anchor: "south")
}

// Pareja de ondas en un plano de referencia situado en x.
// dir = 1: la red queda a la derecha del plano; dir = -1: a la izquierda.
// La onda a entra en la red (naranja) y la onda b sale de ella (azul).
#let ondas(x, dir, ea, eb, y: 0) = {
  onda((x - dir * 22, y + 40), (x - dir * 4, y + 40), ea, c.orange)
  onda((x - dir * 4, y + 22), (x - dir * 22, y + 22), eb, c.blue)
}

// ---------------------------------------------------------------------
// Red de N puertos con ondas incidentes y reflejadas [P-4.12]
// ---------------------------------------------------------------------

#let fig-red-n-puertos() = figure(
  cetz.canvas(length: 1pt, {
    import cetz.draw: *
    caja((-60, -75), (60, 75), [Red de\ microondas], size: 10pt)

    // Puertos de la izquierda: 1 y 2.
    for (y, i) in ((50, "1"), (-50, "2")) {
      line((-170, y), (-60, y), stroke: hilo)
      borne((-170, y))
      content((-178, y), mt[$Z_(0 #i)$], anchor: "east")
      line((-96, y - 12), (-96, y + 50), stroke: plano)
      content((-96, y - 14), mt[$t_#i$], anchor: "north")
      ondas(-96, 1, [$a_#i$], [$b_#i$], y: y)
    }
    content((-135, 0), mt(size: 10pt)[$dots.v$])

    // Puerto n de la derecha.
    line((60, 0), (170, 0), stroke: hilo)
    borne((170, 0))
    content((178, 0), mt[$Z_(0 n)$], anchor: "west")
    line((96, -12), (96, 50), stroke: plano)
    content((96, -14), mt[$t_n$], anchor: "north")
    ondas(96, -1, [$a_n$], [$b_n$], y: 0)
  }),
  caption: [Red de microondas de N puertos. Las ondas $a_i$ entran en la red y las ondas $b_i$ salen de ella; cada puerto tiene su plano terminal $t_i$ y la impedancia característica $Z_(0 i)$ de su línea.],
)

// ---------------------------------------------------------------------
// Red en T [P-4.17]
// ---------------------------------------------------------------------

#let fig-red-t() = figure(
  cetz.canvas(length: 1pt, {
    import cetz.draw: *
    // Rama superior: Z_A, nodo central, Z_B.
    line((0, 0), (20, 0), stroke: hilo)
    caja((20, -7), (60, 7), [$Z_A$], relleno: white, size: 8pt)
    line((60, 0), (150, 0), stroke: hilo)
    caja((150, -7), (190, 7), [$Z_B$], relleno: white, size: 8pt)
    line((190, 0), (215, 0), stroke: hilo)
    // Rama en paralelo: Z_C.
    line((105, 0), (105, -22), stroke: hilo)
    caja((97, -52), (113, -22), [$Z_C$], relleno: white, size: 8pt)
    line((105, -52), (105, -80), stroke: hilo)
    // Hilo inferior.
    line((0, -80), (215, -80), stroke: hilo)
    circle((105, 0), radius: 2, fill: c.ink, stroke: none)
    circle((105, -80), radius: 2, fill: c.ink, stroke: none)
    for p in ((0, 0), (215, 0), (0, -80), (215, -80)) { borne(p) }

    // Corrientes entrantes y tensiones de cada puerto.
    arrow((6, 16), (30, 16), color: c.orange, w: 1pt)
    content((18, 21), mt[$I_1$], anchor: "south")
    arrow((209, 16), (185, 16), color: c.orange, w: 1pt)
    content((197, 21), mt[$I_2$], anchor: "south")
    arrow((-14, -72), (-14, -8), color: c.blue, w: 1pt)
    content((-22, -40), mt[$V_1$], anchor: "east")
    arrow((229, -72), (229, -8), color: c.blue, w: 1pt)
    content((237, -40), mt[$V_2$], anchor: "west")
  }),
  caption: [Red en T de dos puertos, con $Z_A$ y $Z_B$ en serie y $Z_C$ en paralelo. Las corrientes de ambos puertos se toman entrantes.],
)

// ---------------------------------------------------------------------
// Medida con VNA: plano de medida y plano de referencia [P-4.61]
// ---------------------------------------------------------------------

#let fig-vna() = figure(
  cetz.canvas(length: 1pt, {
    import cetz.draw: *
    // Planos de referencia.
    for x in (0, 100, 190, 290) { line((x, -40), (x, 46), stroke: plano) }
    // Hilos de señal y de masa.
    for y in (8, -8) {
      line((0, y), (20, y), stroke: hilo)
      line((80, y), (115, y), stroke: hilo)
      line((175, y), (210, y), stroke: hilo)
      line((270, y), (290, y), stroke: hilo)
    }
    caja((20, -26), (80, 26), [Fuentes\ de error], relleno: c.grey1, size: 8pt)
    caja((115, -26), (175, 26), [DUT], relleno: c.orange1, size: 9pt)
    caja((210, -26), (270, 26), [Fuentes\ de error], relleno: c.grey1, size: 8pt)

    content((0, -46), mt(size: 7pt)[Plano de medida\ del puerto 1], anchor: "north")
    content((100, -46), mt(size: 7pt)[Plano de referencia\ del DUT, puerto 1], anchor: "north")
    content((190, -46), mt(size: 7pt)[Plano de referencia\ del DUT, puerto 2], anchor: "north")
    content((290, -46), mt(size: 7pt)[Plano de medida\ del puerto 2], anchor: "north")

    ondas(0, 1, [$a_1$], [$b_1$])
    ondas(290, -1, [$a_2$], [$b_2$])
  }),
  caption: [Medida de un dispositivo bajo prueba (DUT) con un analizador de redes. Entre el plano de medida y el plano de referencia del DUT hay fuentes de error (cables, conectores, transiciones) que la calibración elimina.],
)

// ---------------------------------------------------------------------
// Cambio del plano de referencia [P-4.66]
// ---------------------------------------------------------------------

#let fig-cambio-plano() = figure(
  cetz.canvas(length: 1pt, {
    import cetz.draw: *
    caja((-30, -26), (30, 26), [$[S]$], size: 10pt)
    for y in (8, -8) {
      line((-140, y), (-30, y), stroke: hilo)
      line((30, y), (140, y), stroke: hilo)
    }
    for x in (-90, -30, 30, 90) { line((x, -40), (x, 46), stroke: plano) }

    content((-90, -46), mt[$t'_1$], anchor: "north")
    content((-30, -46), mt[$t_1$], anchor: "north")
    content((30, -46), mt[$t_2$], anchor: "north")
    content((90, -46), mt[$t'_2$], anchor: "north")

    // Desplazamientos eléctricos.
    let doble = (start: "stealth", end: "stealth", fill: c.ink, scale: .5)
    line((-88, -64), (-32, -64), stroke: .7pt + c.ink, mark: doble)
    content((-60, -68), mt[$theta_1$], anchor: "north")
    line((32, -64), (88, -64), stroke: .7pt + c.ink, mark: doble)
    content((60, -68), mt[$theta_2$], anchor: "north")

    ondas(-90, 1, [$a'_1$], [$b'_1$])
    ondas(-30, 1, [$a_1$], [$b_1$])
    ondas(30, -1, [$a_2$], [$b_2$])
    ondas(90, -1, [$a'_2$], [$b'_2$])
  }),
  caption: [Cambio del plano de referencia: los planos originales $t_1$ y $t_2$ se desplazan hacia fuera las longitudes eléctricas $theta_1$ y $theta_2$ hasta $t'_1$ y $t'_2$.],
)

// ---------------------------------------------------------------------
// Cuadripolo con generador y carga [P-4.84]
// ---------------------------------------------------------------------

#let fig-cuadripolo-carga() = figure(
  cetz.canvas(length: 1pt, {
    import cetz.draw: *
    // Generador con su impedancia en serie.
    circle((-210, 0), radius: 12, fill: white, stroke: hilo)
    content((-210, 0), mt[$tilde$])
    content((-226, 0), mt[$V_g$], anchor: "east")
    line((-210, 12), (-210, 25), (-196, 25), stroke: hilo)
    caja((-196, 18), (-166, 32), [$Z_G$], relleno: white, size: 8pt)
    line((-166, 25), (-70, 25), stroke: hilo)
    line((-210, -12), (-210, -25), (-70, -25), stroke: hilo)

    // Cuadripolo referido a Z0.
    caja((-70, -40), (70, 40), [$(S)_(Z_0)$], size: 10pt)

    // Carga.
    line((70, 25), (170, 25), (170, 12), stroke: hilo)
    rect((164, -12), (176, 12), fill: white, stroke: hilo)
    content((184, 0), mt[$Z_L$], anchor: "west")
    line((170, -12), (170, -25), (70, -25), stroke: hilo)

    // Planos de entrada y de salida.
    for x in (-110, 110) { line((x, -62), (x, 34), stroke: plano) }

    // Coeficientes de reflexión.
    let flecha(a, b, etiqueta) = {
      arrow(a, b, color: c.ink, w: .8pt)
      content(((a.at(0) + b.at(0)) / 2, a.at(1) + 4), mt[#etiqueta], anchor: "south")
    }
    flecha((-110, -52), (-165, -52), [$rho_G$])
    flecha((-110, -52), (-60, -52), [$rho_E$])
    flecha((110, -52), (60, -52), [$rho_S$])
    flecha((110, -52), (165, -52), [$rho_L$])
    content((-85, -60), mt(size: 7pt)[$Z_E$], anchor: "north")
    content((85, -60), mt(size: 7pt)[$Z_S$], anchor: "north")

    // Ondas de potencia del cuadripolo.
    ondas(-110, 1, [$a_1$], [$b_1$], y: 20)
    ondas(110, -1, [$a_2$], [$b_2$], y: 20)
  }),
  caption: [Cuadripolo $(S)$ referido a $Z_0$, con generador $V_g$, $Z_G$ y carga $Z_L$. Cada impedancia tiene su coeficiente de reflexión referido a $Z_0$: $rho_G$, $rho_E$ (entrada), $rho_S$ (salida) y $rho_L$.],
)

// ---------------------------------------------------------------------
// Cascada de dos cuadripolos [P-4.98]
// ---------------------------------------------------------------------

#let fig-cascada() = figure(
  cetz.canvas(length: 1pt, {
    import cetz.draw: *
    caja((-120, -30), (-40, 30), [$(S)^([1])$], size: 10pt)
    caja((40, -30), (120, 30), [$(S)^([2])$], size: 10pt)
    for y in (12, -12) {
      line((-170, y), (-120, y), stroke: hilo)
      line((-40, y), (40, y), stroke: hilo)
      line((120, y), (170, y), stroke: hilo)
    }
    line((0, -22), (0, 22), stroke: plano)

    ondas(-150, 1, [$a_1$], [$b_1$])
    ondas(150, -1, [$a_2$], [$b_2$])
    onda((-24, 52), (24, 52), [$b_2^([1]) = a_1^([2])$], c.blue)
    onda((24, 32), (-24, 32), [$a_2^([1]) = b_1^([2])$], c.orange)

    content((-150, -22), mt(size: 7pt)[$Z_0$], anchor: "north")
    content((0, -26), mt(size: 7pt)[$Z_0$ en la unión], anchor: "north")
    content((150, -22), mt(size: 7pt)[$Z_0$], anchor: "north")
  }),
  caption: [Cascada de dos cuadripolos referidos a la misma $Z_0$. En el plano de unión, la onda que sale de uno es la que entra en el otro.],
)

// ---------------------------------------------------------------------
// Simetría de dos puertas: modos par e impar [P-4.112]
// ---------------------------------------------------------------------

#let fig-par-impar() = figure(
  cetz.canvas(length: 1pt, {
    import cetz.draw: *

    // Red simétrica completa.
    let cx = -170
    caja((cx - 45, -22), (cx + 45, 22), [$[S]$], size: 10pt)
    line((cx - 75, 0), (cx - 45, 0), stroke: hilo)
    line((cx + 45, 0), (cx + 75, 0), stroke: hilo)
    borne((cx - 75, 0))
    borne((cx + 75, 0))
    content((cx - 86, 0), mt[$1$], anchor: "east")
    content((cx + 86, 0), mt[$2$], anchor: "west")
    line((cx, -34), (cx, 34), stroke: plano)
    content((cx, 44), tag[Red simétrica], anchor: "south")

    // Modo par: pared magnética (circuito abierto).
    let cx = 0
    caja((cx - 45, -22), (cx, 22), [$1/2$], size: 9pt)
    line((cx - 75, 0), (cx - 45, 0), stroke: hilo)
    borne((cx - 75, 0))
    content((cx - 86, 0), mt[$1$], anchor: "east")
    line((cx, 0), (cx + 8, 0), stroke: hilo)
    borne((cx + 10.4, 0))
    line((cx, -34), (cx, 34), stroke: plano)
    content((cx, 44), tag[Modo par], anchor: "south")
    content((cx, -40), mt(size: 7.5pt)[pared magnética (c.a.)\ $S_(11 E)$, con $a_2 = a_1$], anchor: "north")

    // Modo impar: pared eléctrica (cortocircuito).
    let cx = 170
    caja((cx - 45, -22), (cx, 22), [$1/2$], size: 9pt)
    line((cx - 75, 0), (cx - 45, 0), stroke: hilo)
    borne((cx - 75, 0))
    content((cx - 86, 0), mt[$1$], anchor: "east")
    line((cx, 0), (cx + 6, 0), stroke: hilo)
    line((cx + 6, -16), (cx + 6, 16), stroke: 1.8pt + c.orange)
    line((cx, -34), (cx, 34), stroke: plano)
    content((cx, 44), tag[Modo impar], anchor: "south")
    content((cx, -40), mt(size: 7.5pt)[pared eléctrica (c.c.)\ $S_(11 O)$, con $a_2 = -a_1$], anchor: "north")
  }),
  caption: [Red de dos puertas simétrica y sus dos semirredes. La excitación par ($a_2 = a_1$) pone un circuito abierto en el plano de simetría y la impar ($a_2 = -a_1$) un cortocircuito.],
)

// ---------------------------------------------------------------------
// Red de cuatro puertas con planos de simetría [P-4.115], [P-4.118]
// ---------------------------------------------------------------------

#let fig-simetria-4p() = figure(
  cetz.canvas(length: 1pt, {
    import cetz.draw: *
    caja((-50, -40), (50, 40), [Red de\ 4 puertos], size: 9pt)
    for (x0, x1, y, izq, n) in (
      (-110, -50, 22, true, "1"),
      (50, 110, 22, false, "2"),
      (50, 110, -22, false, "3"),
      (-110, -50, -22, true, "4"),
    ) {
      line((x0, y), (x1, y), stroke: hilo)
      if izq {
        borne((x0, y))
        content((x0 - 12, y), mt[$#n$], anchor: "east")
      } else {
        borne((x1, y))
        content((x1 + 12, y), mt[$#n$], anchor: "west")
      }
    }
    // Primer plano de simetría (horizontal) y segundo (vertical).
    line((-140, 0), (140, 0), stroke: plano)
    content((138, 3), mt(size: 7pt)[plano de simetría], anchor: "south-east")
    line((0, -58), (0, 58), stroke: plano)
    content((0, 62), mt(size: 7pt)[segundo plano de simetría], anchor: "south")
  }),
  caption: [Red de cuatro puertas con un plano de simetría que separa los puertos 1 y 2 de los puertos 4 y 3, y un segundo plano perpendicular. Los puertos 1 y 4, y los puertos 2 y 3, se corresponden por simetría.],
)
