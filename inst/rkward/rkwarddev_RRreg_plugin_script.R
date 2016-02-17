require(rkwarddev)
rkwarddev.required("0.08-1")

rk.local({
  # define where the plugin should write its files
  output.dir <- tempdir()
  # define the path to components
  ## you must setwd() to the directory $YOURSOURCES/RRreg/inst/rkward/ for this to run!
  rkt.components.root <- normalizePath("rkwarddev_components", mustWork=TRUE)
  # overwrite an existing plugin in output.dir?
  overwrite <- TRUE
  # if you set guess.getters to TRUE, the resulting code will need RKWard >= 0.6.0
  guess.getter <- TRUE
  # define the indentation character for the generated code
  rk.set.indent(by="  ")
  # should empty "else" clauses be kept in the JavaScript code?
  rk.set.empty.e(TRUE)
  # make your plugin translatable by setting this to TRUE
  update.translations <- FALSE

  aboutPlugin <- rk.XML.about(
    name="RRreg",
    author=c(
      person(given="Daniel W.", family="Heck", email="dheck@mail.uni-mannheim.de", role=c("aut", "cre")),
      person(given="Morten", family="Moshagen", email="moshagen@uni-mannheim.de", role=c("aut")),
      person(given="Meik", family="Michalke", email="meik.michalke@hhu.de", role=c("ctb"))
    ),
    about=list(
      desc="Correlation and Regression Analyses for Randomized Response Data",
      version="0.6.2",
      url="http://psycho3.uni-mannheim.de/Home/Research/Software/RRreg/",
      license="GPL-2"
    )
  )

  plugin.dependencies <- rk.XML.dependencies(, dependencies=list(rkward.min="0.6.4", R.min="3.0.0"),
    package=list(
      c(name="RRreg", min="0.6.2")
    )
  )

  # name of the main component, relevant for help page content
  rk.set.comp("Randomized Response Data")

  
  ############
  ## your plugin dialog and JavaScript should be put here
  ############

  source(file.path(rkt.components.root, "component_univariate_analysis.R"), local=TRUE)

  
  ############
  ## help file
  ############

  rkh.summary <- rk.rkh.summary("Correlation and Regression Analyses for Randomized Response Data.")

  rkh.usage <- rk.rkh.usage("Univariate and multivariate methods to analyze
    randomized response (RR) survey designs (e.g., Warner, S. L. (1965).
    Randomized response: A survey technique for eliminating evasive answer
    bias. Journal of the American Statistical Association, 60, 63–69).
    Besides univariate estimates of true proportions, RR variables can be used
    for correlations, as dependent variable in a logistic regression (with or
    without random effects), as predictors in a linear regression, or as
    dependent variable in a beta-binomial ANOVA. For simulation and bootstrap
    purposes, RR data can be generated according to several models.")


  #############
  ## the main call
  ## if you run the following function call, files will be written to output.dir!
  #############
  # this is where things get serious, that is, here all of the above is put together into one plugin
  plugin.dir <- rk.plugin.skeleton(
    about=aboutPlugin,
    dependencies=plugin.dependencies,
    path=output.dir,
    guess.getter=guess.getter,
    scan=c("var", "saveobj", "settings"),
    xml=list(
      dialog=RRreg.rk.UniDialog,
      #wizard=RRreg.rk.wizard,
      logic=RRreg.rk.UniLogic#,
      #snippets=
    ),
    js=list(
      #results.header=FALSE,
      #load.silencer=,
      require="RRreg",
      #variables=,
      #globals=,
      #preprocess=,
      calculate=RRreg.rk.js.calc,
      printout=RRreg.rk.js.print#,
      #doPrintout=
    ),
    rkh=list(
      summary=rkh.summary,
      usage=rkh.usage#,
      #sections=,
      #settings=,
      #related=,
      #technical=
    ),
    create=c("pmap", "xml", "js", "desc"),
    overwrite=overwrite,
    #components=list(),, 
    #provides=c("logic", "dialog"), 
    pluginmap=list(name="Univariate Analysis", hierarchy=c("analysis","Randomized Response Data")), 
    tests=FALSE, 
    edit=FALSE, 
    load=TRUE, 
    show=TRUE,
    gen.info="$SRC/inst/rkward/rkwarddev_RRreg_plugin_script.R"
  )

  # you can make your plugin translatable, see top of script
  if(isTRUE(update.translations)){
    rk.updatePluginMessages(
      file.path(output.dir,"RRreg","inst","rkward","RRreg.pluginmap"),
      # where should translation bug reports go?
      bug_reports="https://mail.kde.org/mailman/listinfo/kde-i18n-doc"
    )
  } else {}

})
