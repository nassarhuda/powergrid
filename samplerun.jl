# January 2017:
d1 = Date(2017,1,1)
d2 = Date(2017,1,31)
dates_length = 6
data,idata = generate_data(d1,d2,"Hourly");

T = generate_hourly_data(data,idata,d1,dates_length)

rep = 10
daytuples = [repeat(1:dates_length,inner=rep*24) repeat(repeat(1:24,inner=rep),outer=dates_length) repeat(1:rep,outer = dates_length*24)]
cmap = PyPlot.matplotlib[:cm][:get_cmap]("viridis")
maxpostransfer = maximum(map(i->maximum(maximum.(T[i])),1:dates_length))

include("run_animation.jl")
gif(anim, "testanim_slow_transfer_scatter.gif", fps=10)

#Aug.21,2017 -- eclipse
d1 = Date(2017,8,21)
d2 = Date(2017,8,30)
dates_length = 2
data,idata = generate_data(d1,d2,"Hourly");

T = generate_hourly_data(data,idata,d1,dates_length)

rep = 10
daytuples = [repeat(1:dates_length,inner=rep*24) repeat(repeat(1:24,inner=rep),outer=dates_length) repeat(1:rep,outer = dates_length*24)]
cmap = PyPlot.matplotlib[:cm][:get_cmap]("viridis")
maxpostransfer = maximum(map(i->maximum(maximum.(T[i])),1:dates_length))

include("run_animation.jl")
gif(anim, "ecliplse.gif", fps=10)

### Inauguration
d1 = Date(2017,1,20)
d2 = Date(2017,1,21)
dates_length = 1
data,idata = generate_data(d1,d2,"Hourly");

T = generate_hourly_data(data,idata,d1,dates_length)

rep = 10
daytuples = [repeat(1:dates_length,inner=rep*24) repeat(repeat(1:24,inner=rep),outer=dates_length) repeat(1:rep,outer = dates_length*24)]
cmap = PyPlot.matplotlib[:cm][:get_cmap]("viridis")
maxpostransfer = maximum(map(i->maximum(maximum.(T[i])),1:dates_length))

include("run_animation.jl")
gif(anim, "inauguration.gif", fps=10)