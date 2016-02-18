# name of the active component, relevant for help page content
rk.set.comp("Logistic Regression")

## dialog section

varsLog <- rk.XML.varselector(id.name="varsLog")
# data
varLogData <- rk.XML.varslot(
  label="Data (data frame)",
  source=varsLog,
  classes=c("data.frame"),
  required=TRUE,
  id.name="varLogData"
)
varLogDependend <- rk.XML.varslot(
  label="Dependent variable",
  source=varsLog,
  required=TRUE,
  id.name="varLogDependend"
)
varLogFactors <- rk.XML.varslot(
  label="Factors",
  source=varsLog,
  required=TRUE,
  multi=TRUE,
  id.name="varLogFactors"
)

# formula
#varLogRegFormula <- rk.XML.cbox("foo")
varLogRegFormula <- rk.XML.formula(
  label="Regression model",
  fixed=varLogFactors,
  dependent=varLogDependend,
  id.name="varLogRegFormula"
)

# model
logDrpModel <- rk.XML.dropdown(
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
  id.name="logDrpModel"
)

# p
logFrmProbabilities <- rk.XML.frame(
  rk.XML.row(
    logSpinp1 <- rk.XML.spinbox(
      label="p<sub>1</sub>",
      min=0,
      max=1,
      initial=1,
      id.name="logSpinp1"
    ),
    logSpinp2 <- rk.XML.spinbox(
      label="p<sub>2</sub>",
      min=0,
      max=1,
      initial=0,
      id.name="logSpinp2"
    ),
    logInputp1 <- rk.XML.input(
      label="p<sub>1</sub>",
      initial="1/1",
      id.name="logInputp1"
    ),
    logInputp2 <- rk.XML.input(
      label="p<sub>2</sub>",
      initial="0/1",
      id.name="logInputp2"
    )
  ),
  rk.XML.row(
    logChkProbInput <- rk.XML.cbox("Manual input")
  ),
  label="Probabilities",
  id.name="logFrmProbabilities"
)
  

# group
varLogGroup <- rk.XML.varslot(
  label="Groups (numeric vector)",
  source=varsLog,
  classes=c("numeric"),
  required=FALSE,
  id.name="varLogGroup"
)

# n.response
logSpinNResponse <- rk.XML.spinbox(
  label="Responses per participant",
  min=1,
  initial=1,
  real=FALSE,
  id.name="logSpinNResponse"
)

# LRTest
logChkLRTest <- rk.XML.cbox(label="Test regression coefficients (likelihood ratio)", id.name="logChkLRTest")

# fit.n
logSpinFitN <- rk.XML.spinbox(
  label="Number of fitting replications",
  min=1,
  initial=3,
  real=FALSE,
  id.name="logSpinFitN"
)

# EM.max
logSpinEM <- rk.XML.spinbox(
  label="EM algorithm",
  min=1,
  initial=1000,
  real=FALSE,
  id.name="logSpinEM"
)

# optim.max
logSpinOptim <- rk.XML.spinbox(
  label="Optim",
  min=1,
  initial=500,
  real=FALSE,
  id.name="logSpinOptim"
)

logFrmMaxIter <- rk.XML.frame(
  rk.XML.row(
    logSpinEM,
    logSpinOptim
  ),
  label="Maximum number of iterations",
  id.name="logFrmMaxIter"
)


logSaveResults <- rk.XML.saveobj("Save results to workspace", initial="RRLogResult")

RRreg.LogDialog <- rk.XML.dialog(
  rk.XML.tabbook(
    tabs=list(
      Data=rk.XML.row(
        rk.XML.col(
          varsLog
        ),
        rk.XML.col(
          varLogData,
          varLogDependend,
          varLogFactors,
          varLogGroup,
          logDrpModel,
          logFrmProbabilities
        )
      ),
      "Regression Model"=rk.XML.col(
        varLogRegFormula,
        rk.XML.stretch()
      ),
      "Options"=rk.XML.col(
        logFrmLRTest,
        rk.XML.row(
          logSpinNResponse,
          logSpinFitN
        ),
        logFrmMaxIter,
        rk.XML.stretch(),
        logSaveResults
      )
    )
  ),
  label="Logistic Regression for Randomized Response Data"
)

## logic section
RRreg.LogLogic <- rk.XML.logic(
  rk.XML.connect(governor="current_object", client=varLogData, set="available"),
  rk.XML.connect(governor=varLogData, client=varsLog, get="available", set="root"),
  logLgcData <- rk.XML.convert(sources=list(available=varLogData), mode=c(notequals="")),
  rk.XML.connect(governor=logLgcData, client=varLogDependend, set="enabled"),
  rk.XML.connect(governor=logLgcData, client=varLogFactors, set="enabled"),
  rk.XML.connect(governor=logLgcData, client=varLogRegFormula, set="enabled"),
  # replace spinboxes with manual input fields
  rk.XML.connect(governor=logChkProbInput, client=logSpinp1, not=TRUE, set="visible"),
  rk.XML.connect(governor=logChkProbInput, client=logInputp1, set="visible"),
  rk.XML.connect(governor=logChkProbInput, client=logSpinp2, not=TRUE, set="visible"),
  rk.XML.connect(governor=logChkProbInput, client=logInputp2, set="visible"),
  # two p
  logLgcModelUQTknown <- rk.XML.convert(list(string=logDrpModel), mode=c(equals="UQTknown"), id.name="logLgcModelUQTknown"),
  logLgcModelUQTunknown <- rk.XML.convert(list(string=logDrpModel), mode=c(equals="UQTunknown"), id.name="logLgcModelUQTunknown"),
  logLgcModelKuk <- rk.XML.convert(list(string=logDrpModel), mode=c(equals="Kuk"), id.name="logLgcModelKuk"),
  logLgcModelFR <- rk.XML.convert(list(string=logDrpModel), mode=c(equals="FR"), id.name="logLgcModelFR"),
  logLgcModelCDM <- rk.XML.convert(list(string=logDrpModel), mode=c(equals="CDM"), id.name="logLgcModelCDM"),
  logLgcModelCDMsym <- rk.XML.convert(list(string=logDrpModel), mode=c(equals="CDMsym"), id.name="logLgcModelCDMsym"),
  logLgcModelSLD <- rk.XML.convert(list(string=logDrpModel), mode=c(equals="SLD"), id.name="logLgcModelSLD"),
  logLgcModelcustom <- rk.XML.convert(list(string=logDrpModel), mode=c(equals="custom"), id.name="logLgcModelcustom"),
  logLgcNeedsP2 <- rk.XML.convert(
    sources=list(
      logLgcModelUQTknown,
      logLgcModelUQTunknown,
      logLgcModelKuk, logLgcModelFR,
      logLgcModelCDM,
      logLgcModelCDMsym,
      logLgcModelSLD,
      logLgcModelcustom
    ),
    mode=c(or=""),
    id.name="logLgcNeedsP2"
  ),
  logLgcNeedsGroup <- rk.XML.convert(sources=list(logLgcNeedsP2, logLgcData), mode=c(and=""), id.name="logLgcNeedsGroup"),
  logLgcEnableGroup <- rk.XML.connect(governor=logLgcNeedsGroup, client=varLogGroup, set="enabled"),
  logLgcRequireGroup <- rk.XML.connect(governor=logLgcNeedsGroup, client=varLogGroup, set="required"),
  logLgcEnableSP2 <- rk.XML.connect(governor=logLgcNeedsP2, client=logSpinp2, set="enabled"),
  logLgcEnableIP2 <- rk.XML.connect(governor=logLgcNeedsP2, client=logInputp2, set="enabled")
)

# ## wizard section
## JavaScript calculate
  log.js.p2.enabled <- rk.JS.vars(logSpinp2, modifiers="enabled")
  RRreg.log.js.calc <- rk.paste.JS(
#     log.js.response.df <- rk.JS.vars(varLogRegFormula, modifiers="shortname"),
    log.js.group.df <- rk.JS.vars(varLogGroup, modifiers="shortname"),
    log.js.p2.enabled,
    echo("RRLogResult <- RRlog("),
    js(
      if(varLogRegFormula){
        echo("\n  formula=", varLogRegFormula)
      } else {},
      if(varLogData){
        echo(",\n  data=", varLogData)
      } else {},
      echo(",\n  model=\"", logDrpModel, "\""),
      if(log.js.p2.enabled){
        if(logChkProbInput){
          echo(",\n  p=c(", logInputp1, ", ", logInputp2, ")")
        } else {
          echo(",\n  p=c(", logSpinp1, ", ", logSpinp2, ")")
        }
      } else {
        if(logChkProbInput){
          echo(",\n  p=", logInputp1)
        } else {
          echo(",\n  p=", logSpinp1)
        }
      },
      if(log.js.p2.enabled && varLogGroup){
        if(varLogData){
          echo(",\n  group=", log.js.group.df)
        } else {
          echo(",\n  group=", varLogGroup)
        }
      } else {},
      if(logSpinNResponse != 1){
        echo(",\n  n.response=", logSpinNResponse)
      } else {}
    ),
    tf(logChkLRTest, opt="LR.test", level=2),
    js(
      if(logSpinFitN != 3){
        echo(",\n  fit.n=", logSpinFitN)
      } else {},
      if(logSpinEM != 1000){
        echo(",\n  EM.max=", logSpinEM)
      } else {},
      if(logSpinOptim != 500){
        echo(",\n  optim.max=", logSpinOptim)
      } else {}
    ),
    echo("\n)\n\n")
  )

## JavaScript printout
  RRreg.log.js.print <- rk.paste.JS(
    echo("rk.print(summary(RRLogResult))\n")
  )

## make a whole component
RRreg.log.component <- rk.plugin.component(
  "Logistic Regression",
  xml=list(
    logic=RRreg.LogLogic,
    dialog=RRreg.LogDialog
  ),
  js=list(
    require="RRreg",
    calculate=RRreg.log.js.calc,
    printout=RRreg.log.js.print
  ),
  guess.getter=guess.getter,
  hierarchy=list("analysis","Randomized Response Data"),
  create=c("xml", "js"),
  gen.info="$SRC/inst/rkward/rkwarddev_components/component_logistic_regression.R"
)
