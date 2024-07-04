# using julia and NMF
# some includes / various packages
begin
    using NMF
    using LinearAlgebra
    using Statistics
    using Images
    using FileIO
    using ImageIO
    using Glob
    using Interpolations
    using ProgressBars
    using Plots
end

# assumes you have downloaded some data from web!
data_directory = "./lfw-deepfunneled/";
if !isdir(data_directory)
    println("""
    # download data with curl
    curl http://vis-www.cs.umass.edu/lfw/lfw-deepfunneled.tgz > lfw-deep.tgz
    # and unpack it
    tar xvfz lfw-deepfunneled.tgz
    """)
    error("uhoh - need to download data ")
end
files = readdir(glob"*/*.*", data_directory )



# save some time...
nFilesToUse = 1000
imsize = (150,150)
imstack = zeros(Gray{N0f8}, imsize...,nFilesToUse);
# loop over files, read them in, resize, grayscale them
for f in ProgressBar(1:nFilesToUse)
    imstack[:,:,f] = imresize(  Gray.(load(files[f])), imsize, method=Linear())
end

# let's only use the central square of images
sz_x = 51:100
sz_y = 51:100
centered = view(imstack,sz_x, sz_y,:)
mosaicview(centered[:,:,1:20], nrow=2)

# how many pixels in each?
imsz_centered = size(centered)[1:2]

# turn them into a giant nPixels x nImages matrix
theI = Float64.(reshape(centered,(prod(imsz_centered),:)));

# to look at the reshaped images, you can use:
Gray.(theI) # which converts Float values to grayscale and they get shown!

nFeatures = 64

# using NMF / slightly longer than 10s on my laptop
@time N = nnmf(theI, nFeatures)

# turn them back into "images" and scale display range
W = reshape(N.W, imsz_centered...,:)
f = scaleminmax(quantile(W, [0.01, 0.99])...)
heatmap(mosaicview(f.(W[:,:,1:20]), npad=2, 
        nrow = 4), 
        aspect_ratio=:equal,
        cmap=:grays,
        clim=(0,1),
        yflip=true,
        axis=:false,
        legend=false,
        title="NMF")


# using SVD
S = svd(theI)
SU = reshape(S.U, imsz_centered...,:)
g = scalesigned(quantile(SU, [0.01,0.5, 0.99])...)


heatmap(mosaicview(g.(SU[:,:,1:20]), npad=2, 
        nrow = 4), 
        aspect_ratio=:equal,
        cmap=:grays,
        yflip=true,
        axis=:false,
        #legend=false,
        title="SVD")
