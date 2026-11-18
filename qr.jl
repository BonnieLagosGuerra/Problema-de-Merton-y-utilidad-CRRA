# Genera el código QR del póster que apunta al repositorio.
# Uso:  julia qr.jl https://github.com/BonnieLagosGuerra/Problema-de-Merton-y-utilidad-CRRA
import Pkg
Pkg.activate(temp=true)          # entorno temporal: QRCoders no es dependencia del proyecto
Pkg.add("QRCoders"; io=devnull)
using QRCoders

url = length(ARGS) >= 1 ? ARGS[1] : "https://github.com/BonnieLagosGuerra/Problema-de-Merton-y-utilidad-CRRA"
salida = joinpath(@__DIR__, "poster", "qr.png")
mkpath(dirname(salida))
exportqrcode(url, salida; eclevel=High(), width=4, pixels=1200)   # corrección de errores alta y buena resolución
println("QR de ", url, " guardado en ", salida)
