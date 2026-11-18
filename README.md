# Control estocástico del problema de Merton

Proyecto del curso **MA4703-1 Control Óptimo: Teoría y Laboratorio** (FCFM, Universidad de Chile, primavera 2026).

**Integrantes:** Bonnie A. Lagos Guerra y Javier Cruz Araneda.
**Profesor:** Héctor Ramírez C. · **Auxiliares:** Diego Morales y Hernán Torres V. · **Ayudante:** Fraick Reyes.

Un inversionista reparte su capital entre un banco (tasa $r$) y una acción de Black–Scholes (retorno $\mu$, volatilidad $\sigma$), y elige en cada instante la fracción $\Pi_t$ invertida en la acción y su consumo $C_t$, para maximizar

$$
V(x)=\sup_{(\Pi,C)\in\mathcal A}\ \mathbb E_x\int_0^\infty e^{-\gamma t}\,U(C_t)\,dt,\qquad U(c)=\frac{c^{1-\eta}-1}{1-\eta}.
$$

Con $r=0.03$, $\mu=0.08$, $\sigma=0.2$, $\eta=2$ y $\gamma=0.05$, la solución de Merton es $\Pi^*=\frac{\mu-r}{\eta\sigma^2}=0.625$ y $C^*=\nu X$ con $\nu\approx0.0478$. El proyecto quita uno a uno los supuestos de esta fórmula y mide cuánto cuesta cada uno, con el **capital equivalente** $x_{CE}$ ($V(x_{CE})=J$).

## Contenido

| Archivo | Qué es |
| --- | --- |
| [`merton.ipynb`](merton.ipynb) | Notebook único en Julia con todo el proyecto. Se ejecuta de arriba hacia abajo. |
| `figuras/` | Figuras del póster (PNG de 300 dpi), generadas por el notebook. |
| `poster/` | Póster en PDF. |
| `avances/` | Notebooks originales de los avances 2 a 5 (historial; el notebook único los reemplaza y corrige). |
| `Project.toml`, `Manifest.toml` | Entorno de Julia con las versiones exactas de los paquetes. |
| `qr.jl` | Genera el código QR del póster que apunta a este repositorio. |

### Secciones del notebook

| Sección | Objetivo del enunciado | Resultado principal |
| --- | --- | --- |
| 1 | Problema, utilidad CRRA y controles admisibles | Solución de Merton y su verificación por dualidad |
| 2 | Controlabilidad | No es controlable en el sentido clásico; es exactamente controlable con restricciones: $\mathcal R(T)=\{\xi\ge0:\mathbb E[H_T\xi]\le x\}$ |
| 3 | Simulación y Monte-Carlo | Esquema log-Euler exacto, estimador sin sesgo de truncamiento, variables antitéticas |
| 4 | Filtro de Kalman | $\sigma$ se estima bien; el error de $\mu$ es $\sigma/\sqrt T$ y harían falta más de 61 años de datos |
| 5 | Existencia y HJB numérica | Esquema *upwind* monótono + iteración de Howard; reproduce $\Pi^*$ y $\nu$ sin usar la fórmula |
| 6 | Controles restringidos | Fracción acotada: proyectar $\Pi^*$; los controles markovianos no pierden valor |
| 7 | Horizonte finito y tiempo de parada | Consumo $1/L(T-t)$, vida incierta, piso de liquidación |
| 8 | Extensiones | Varios activos, $\mu(t)$ y $\sigma(t)$, cambios acotados de $\Pi$, costos de transacción |
| 9 | Conclusiones | Incluye una celda con todos los números del póster |

## Cambios respecto de los avances

El notebook único reproduce todos los números de los avances, salvo el piso de liquidación (Sección 7.5), donde se corrigió:

* **Condición de borde en el piso.** Desde arriba del piso el inversionista puede evitarlo para siempre ($\Pi=0$, $C\le rX$), así que la condición de Dirichlet $V=\Psi$ se reemplazó por la mejor opción entre liquidar y quedarse encima (restricción de estado).
* **Política en el nodo del piso.** Antes se calculaba con la homotecia, que no vale ahí, y daba $\Pi=\Pi^*$ en ese nodo; ahora es $\Pi=0$.
* **Malla.** $V_\ell(x_0)$ se interpola (antes se tomaba el nodo más cercano) y se usa una malla más fina. Los capitales equivalentes pasan de 98.9 / 94.9 / 85.2 a 99.1 / 94.8 / 85.7 para pisos 20 / 50 / 80.

Además: la mejora de política usa el mismo criterio en todos los solvers, ningún experimento depende de variables globales de otra sección y se agregó la Sección 2 (controlabilidad) con una verificación numérica.

## Cómo ejecutarlo

Requiere [Julia](https://julialang.org/downloads/) 1.12 y Jupyter con el kernel de Julia ([IJulia](https://github.com/JuliaLang/IJulia.jl)).

```bash
git clone https://github.com/BonnieLagosGuerra/Problema-de-Merton-y-utilidad-CRRA.git
cd Problema-de-Merton-y-utilidad-CRRA
julia --project=. -e 'using Pkg; Pkg.instantiate()'   # instala las versiones exactas del Manifest
julia -e 'using Pkg; Pkg.add("IJulia")'               # solo la primera vez, si no tienen IJulia
jupyter lab merton.ipynb                              # o abrirlo en VS Code
```

Luego *Restart Kernel and Run All Cells*. La ejecución completa toma unos minutos; las figuras quedan en `figuras/`. Todas las simulaciones usan semillas fijas, así que los números se reproducen.

## Código QR

`poster/qr.png` apunta a este repositorio (https://github.com/BonnieLagosGuerra/Problema-de-Merton-y-utilidad-CRRA). Para regenerarlo:

```bash
julia qr.jl https://github.com/BonnieLagosGuerra/Problema-de-Merton-y-utilidad-CRRA
```

## Referencias

1. I. Karatzas y S. E. Shreve (1991). *Brownian Motion and Stochastic Calculus*. Springer, Graduate Texts in Mathematics.
2. H. Kushner y P. Dupuis (1992). *Numerical Methods for Stochastic Control Problems in Continuous Time*. Springer, Applications of Mathematics.
3. K. Ross (2008). *Stochastic Control in Continuous Time*. Department of Statistics, Stanford University.
4. S. Stojanovic (2002). *Computational Financial Mathematics: Trading Stocks and Options with MATHEMATICA*. Birkhäuser.
5. J. Yong y X. Y. Zhou (1999). *Stochastic Controls: Hamiltonian Systems and HJB Equations*. Springer, Applications of Mathematics.
6. R. C. Merton (1969). Lifetime portfolio selection under uncertainty: the continuous-time case. *Review of Economics and Statistics* 51(3), 247–257.
7. M. H. A. Davis y A. R. Norman (1990). Portfolio selection with transaction costs. *Mathematics of Operations Research* 15(4), 676–713.
