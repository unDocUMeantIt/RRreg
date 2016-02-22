# name of the active component, relevant for help page content
rk.set.comp("Linear Regression")

## dialog section

varsLin <- rk.XML.varselector(id.name="varsLin")
# data
varLinData <- rk.XML.varslot(
  label="Data (data frame)",
  source=varsLin,
  classes=c("data.frame"),
  required=TRUE,
  id.name="varLinData"
)
varLinDependend <- rk.XML.varslot(
  label="Dependent variable",
  source=varsLin,
  required=TRUE,
  id.name="varLinDependend"
)
varLinFactors <- rk.XML.varslot(
  label="Factors",
  source=varsLin,
  required=TRUE,
  multi=TRUE,
  id.name="varLinFactors"
)

# formula
varLinRegFormula <- rk.XML.formula(
  label="Regression model",
  fixed=varLinFactors,
  dependent=varLinDependend,
  id.name="varLinRegFormula"
)

linOptSetModels <- rk.XML.optionset(
  content=rk.XML.row(
    # model
    linDrpModel <- rk.XML.dropdown(
      label="Model specification",
      options=list(
        "Warner"=c(val="Warner", chk=TRUE),
        "UQTknown"=c(val="UQTknown"),
        "UQTunknown"=c(val="UQTunknown"),
        "Mangat"=c(val="Mangat"),
        "Kuk"=c(val="Kuk"),
        "FR"=c(val="FR"),
        "Crosswise"=c(val="Crosswise"),
        "CDM"=c(val="CDM"),
        "CDMsym"=c(val="CDMsym"),
        "SLD"=c(val="SLD"),
        "custom"=c(val="custom")
      ),
      id.name="linDrpModel"
    ),
    # p
    linFrmProbabilities <- rk.XML.frame(
      rk.XML.row(
        linSpinp1 <- rk.XML.spinbox(
          label="p<sub>1</sub>",
          min=0,
          max=1,
          initial=1,
          id.name="linSpinp1"
        ),
        linSpinp2 <- rk.XML.spinbox(
          label="p<sub>2</sub>",
          min=0,
          max=1,
          initial=0,
          id.name="linSpinp2"
        ),
        linInputp1 <- rk.XML.input(
          label="p<sub>1</sub>",
          initial="1/1",
          id.name="linInputp1"
        ),
        linInputp2 <- rk.XML.input(
          label="p<sub>2</sub>",
          initial="0/1",
          id.name="linInputp2"
        )
      ),
      rk.XML.row(
        linChkProbInput <- rk.XML.cbox("Manual input")
      ),
      label="Probabilities",
      id.name="linFrmProbabilities"
    ),
    id.name="row_linDrpModel"
  ),
  optioncolumn=list(
    ocolLinDrpModel <- rk.XML.optioncolumn(connect=linDrpModel, modifier="string", id.name="ocolLinDrpModel")
  ),
  logic=rk.XML.logic(
    # replace spinboxes with manual input fields
    rk.XML.connect(governor=linChkProbInput, client=linSpinp1, not=TRUE, set="visible"),
    rk.XML.connect(governor=linChkProbInput, client=linInputp1, set="visible"),
    rk.XML.connect(governor=linChkProbInput, client=linSpinp2, not=TRUE, set="visible"),
    rk.XML.connect(governor=linChkProbInput, client=linInputp2, set="visible"),
    # two p
    linLgcModelUQTknown <- rk.XML.convert(list(string=linDrpModel), mode=c(equals="UQTknown"), id.name="linLgcModelUQTknown"),
    linLgcModelUQTunknown <- rk.XML.convert(list(string=linDrpModel), mode=c(equals="UQTunknown"), id.name="linLgcModelUQTunknown"),
    linLgcModelKuk <- rk.XML.convert(list(string=linDrpModel), mode=c(equals="Kuk"), id.name="linLgcModelKuk"),
    linLgcModelFR <- rk.XML.convert(list(string=linDrpModel), mode=c(equals="FR"), id.name="linLgcModelFR"),
    linLgcModelCDM <- rk.XML.convert(list(string=linDrpModel), mode=c(equals="CDM"), id.name="linLgcModelCDM"),
    linLgcModelCDMsym <- rk.XML.convert(list(string=linDrpModel), mode=c(equals="CDMsym"), id.name="linLgcModelCDMsym"),
    linLgcModelSLD <- rk.XML.convert(list(string=linDrpModel), mode=c(equals="SLD"), id.name="linLgcModelSLD"),
    linLgcModelcustom <- rk.XML.convert(list(string=linDrpModel), mode=c(equals="custom"), id.name="linLgcModelcustom"),
    linLgcNeedsP2 <- rk.XML.convert(
      sources=list(
        linLgcModelUQTknown,
        linLgcModelUQTunknown,
        linLgcModelKuk, linLgcModelFR,
        linLgcModelCDM,
        linLgcModelCDMsym,
        linLgcModelSLD,
        linLgcModelcustom
      ),
      mode=c(or=""),
      id.name="linLgcNeedsP2"
    ),
    linLgcNeedsGroup <- rk.XML.convert(sources=list(linLgcNeedsP2, linLgcData), mode=c(and=""), id.name="linLgcNeedsGroup"),
    linLgcEnableGroup <- rk.XML.connect(governor=linLgcNeedsGroup, client=varLinGroup, set="enabled"),
    linLgcRequireGroup <- rk.XML.connect(governor=linLgcNeedsGroup, client=varLinGroup, set="required"),
    linLgcEnableSP2 <- rk.XML.connect(governor=linLgcNeedsP2, client=linSpinp2, set="enabled"),
    linLgcEnableIP2 <- rk.XML.connect(governor=linLgcNeedsP2, client=linInputp2, set="enabled")
  ),
  id.name="linOptSetModels"
)


  

# group
varLinGroup <- rk.XML.varslot(
  label="Groups (numeric vector)",
  source=varsLin,
  classes=c("numeric"),
  required=FALSE,
  id.name="varLinGroup"
)

# bs.n
linSpinNumSamples <- rk.XML.spinbox(
  label="Number of samples",
  min=1,
  initial=1,
  real=FALSE,
  id.name="linSpinNumSamples"
)

# maxiter
linSpinMaxit <- rk.XML.spinbox(
  label="Maximum number of iterations",
  min=1,
  initial=1000,
  real=FALSE,
  id.name="linSpinMaxit"
)

# nCPU
linSpinCPU <- rk.XML.spinbox(
  label="Number of CPU cores",
  min=1,
  initial=1,
  real=FALSE,
  id.name="linSpinCPU"
)

# fit.n
linSpinFitN <- rk.XML.spinbox(
  label="Number of fitting replications",
  min=1,
  initial=3,
  real=FALSE,
  id.name="linSpinFitN"
)

linFrmMaxIter <- rk.XML.frame(
  rk.XML.row(
    linSpinNumSamples,
    linSpinMaxit,
    linSpinCPU
  ),
  label="Bootstrap options",
  id.name="linFrmMaxIter"
)


linSaveResults <- rk.XML.saveobj("Save results to workspace", initial="RRLinResult")

RRreg.LinDialog <- rk.XML.dialog(
  rk.XML.tabbook(
    tabs=list(
      Data=rk.XML.row(
        rk.XML.col(
          varsLin
        ),
        rk.XML.col(
          varLinData,
          varLinDependend,
          varLinFactors,
          varLinGroup,
          linOptSetModels
        )
      ),
      "Regression Model"=rk.XML.col(
        varLinRegFormula,
        rk.XML.stretch()
      ),
      "Options"=rk.XML.col(
        rk.XML.row(
          linSpinFitN
        ),
        linFrmMaxIter,
        rk.XML.stretch(),
        linSaveResults
      )
    )
  ),
  label="Linear Regression for Randomized Response Data"
)

## logic section
RRreg.LinLogic <- rk.XML.logic(
  rk.XML.connect(governor="current_object", client=varLinData, set="available"),
  rk.XML.connect(governor=varLinData, client=varsLin, get="available", set="root"),
  linLgcData <- rk.XML.convert(sources=list(available=varLinData), mode=c(notequals="")),
  rk.XML.connect(governor=linLgcData, client=varLinDependend, set="enabled"),
  rk.XML.connect(governor=linLgcData, client=varLinFactors, set="enabled"),
  rk.XML.connect(governor=linLgcData, client=varLinRegFormula, set="enabled")
)

# ## wizard section
## JavaScript calculate
  lin.js.p2.enabled <- rk.JS.vars(linSpinp2, modifiers="enabled")
  RRreg.lin.js.calc <- rk.paste.JS(
#     lin.js.response.df <- rk.JS.vars(varLinRegFormula, modifiers="shortname"),
    lin.js.group.df <- rk.JS.vars(varLinGroup, modifiers="shortname"),
    lin.js.p2.enabled,
    echo("RRLinResult <- RRlin("),
    js(
      if(varLinRegFormula){
        echo("\n  formula=", varLinRegFormula)
      } else {},
      if(varLinData){
        echo(",\n  data=", varLinData)
      } else {},
#       echo(",\n  model=\"", linDrpModel, "\""),
      if(lin.js.p2.enabled){
        if(linChkProbInput){
          echo(",\n  p=c(", linInputp1, ", ", linInputp2, ")")
        } else {
          echo(",\n  p=c(", linSpinp1, ", ", linSpinp2, ")")
        }
      } else {
        if(linChkProbInput){
          echo(",\n  p=", linInputp1)
        } else {
          echo(",\n  p=", linSpinp1)
        }
      },
      if(lin.js.p2.enabled && varLinGroup){
        if(varLinData){
          echo(",\n  group=", lin.js.group.df)
        } else {
          echo(",\n  group=", varLinGroup)
        }
      } else {},
      if(linSpinNumSamples != 1){
        echo(",\n  n.response=", linSpinNumSamples)
      } else {}
    ),
    js(
      if(linSpinFitN != 3){
        echo(",\n  fit.n=", linSpinFitN)
      } else {},
      if(linSpinMaxit != 1000){
        echo(",\n  maxit=", linSpinMaxit)
      } else {},
      if(linSpinCPU != 1){
        echo(",\n  nCPU=", linSpinCPU)
      } else {}
    ),
    echo("\n)\n\n")
  )

## JavaScript printout
  RRreg.lin.js.print <- rk.paste.JS(
    echo("rk.print(summary(RRLinResult))\n")
  )

## make a whole component
RRreg.lin.component <- rk.plugin.component(
  "Linear Regression",
  xml=list(
    logic=RRreg.LinLogic,
    dialog=RRreg.LinDialog
  ),
  js=list(
    require="RRreg",
    calculate=RRreg.lin.js.calc,
    printout=RRreg.lin.js.print
  ),
  guess.getter=guess.getter,
  hierarchy=list("analysis","Randomized Response Data"),
  create=c("xml", "js"),
  gen.info="$SRC/inst/rkward/rkwarddev_components/component_linear_regression.R"
)
