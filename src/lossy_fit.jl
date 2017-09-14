function lossy_fit(x, y; l = w-> 1, c = w->1, r = w->1, g = w->1)
    # take the xdata and ydata and fit it to an arbitrary impedance model.
    Zc(w) = sqrt((r(w) + im*w*l(w))/(g(w) + im*w*c(w)))
    b = fft_with_units(x,y)
end
