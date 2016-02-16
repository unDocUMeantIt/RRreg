## used as the plugin's main component
# name of the active component, relevant for help page content
rk.set.comp("Univariate Analysis")

## dialog section

varsUni <- rk.XML.varselector(id.name="varsUni")
# response
varUniResponse <- rk.XML.varslot(
  label="Responses (dichotomous vector)",
  source=varsUni,
  classes=c("vector"),
  required=TRUE,
  id.name="varUniResponse"
)
# data
varUniData <- rk.XML.varslot(
  label="Data (data frame)",
  source=varsUni,
  classes=c("data.frame"),
  required=FALSE,
  id.name="varUniData"
)

# model
uniDrpModel <- rk.XML.dropdown(
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
    "mix.norm"=c(val="mix.norm"),
    "mix.exp"=c(val="mix.exp"),
    "mix.unknown"=c(val="mix.unknown"),
    "custom"=c(val="custom")
  ),
  id.name="uniDrpModel"
)

# p
uniFrmProbabilities <- rk.XML.frame(
  rk.XML.row(
    uniSpinp1 <- rk.XML.spinbox(
      label="p<sub>1</sub>",
      min=0,
      max=1,
      initial=1,
      id.name="uniSpinp1"
    ),
    uniSpinp2 <- rk.XML.spinbox(
      label="p<sub>2</sub>",
      min=0,
      max=1,
      initial=0,
      id.name="uniSpinp2"
    ),
    uniSpinp3 <- rk.XML.spinbox(
      label="p<sub>3</sub>",
      min=0,
      max=1,
      initial=0,
      id.name="uniSpinp3"
    )
  ),
  label="Probabilities",
  id.name="uniFrmProbabilities"
)
  

# group
varUniGroup <- rk.XML.varslot(
  label="Groups (numeric vector)",
  source=varsUni,
  classes=c("vector"),
  required=FALSE,
  id.name="varUniGroup"
)

# MLest
uniFrmMLest <- rk.XML.frame(
  uniChkMLest <- rk.XML.cbox(label="Maximum likelihood instead of moment estimates", id.name="uniChkMLest"),
  label="Options",
  id.name="uniFrmMLest"
)

uniSaveResults <- rk.XML.saveobj("Save results to workspace", initial="RRUniResult")

RRreg.rk.UniDialog <- rk.XML.dialog(
  rk.XML.row(
    rk.XML.col(
      varsUni
    ),
    rk.XML.col(
      varUniResponse,
      varUniData,
      varUniGroup,
      uniDrpModel,
      uniFrmProbabilities,
      rk.XML.stretch(),
      uniFrmMLest,
      uniSaveResults
    )
  ),
  label="Univariate Analysis"
)

## logic section
RRreg.rk.UniLogic <- rk.XML.logic(
  # two p
  uniLgcModelUQTknown <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="UQTknown"), id.name="uniLgcModelUQTknown"),
  uniLgcModelUQTunknown <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="UQTunknown"), id.name="uniLgcModelUQTunknown"),
  uniLgcModelKuk <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="Kuk"), id.name="uniLgcModelKuk"),
  uniLgcModelFR <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="FR"), id.name="uniLgcModelFR"),
  uniLgcModelCDM <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="CDM"), id.name="uniLgcModelCDM"),
  uniLgcModelCDMsym <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="CDMsym"), id.name="uniLgcModelCDMsym"),
  uniLgcModelSLD <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="SLD"), id.name="uniLgcModelSLD"),
  uniLgcModelcustom <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="custom"), id.name="uniLgcModelcustom"),
  # three p
  uniLgcModelmixNorm <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="mix.norm"), id.name="uniLgcModelmixNorm"),
  uniLgcModelmixExp <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="mix.exp"), id.name="uniLgcModelmixExp"),
  uniLgcModelmixUnknown <- rk.XML.convert(list(string=uniDrpModel), mode=c(equals="mix.unknown"), id.name="uniLgcModelmixUnknown"),
  uniLgcNeedsP2 <- rk.XML.convert(
    sources=list(
      uniLgcModelUQTknown,
      uniLgcModelUQTunknown,
      uniLgcModelKuk, uniLgcModelFR,
      uniLgcModelCDM,
      uniLgcModelCDMsym,
      uniLgcModelSLD,
      uniLgcModelcustom,
      uniLgcModelmixNorm,
      uniLgcModelmixExp,
      uniLgcModelmixUnknown
    ),
    mode=c(or=""),
    id.name="uniLgcNeedsP2"
  ),
  uniLgcNeedsP3 <- rk.XML.convert(
    sources=list(
      uniLgcModelmixNorm,
      uniLgcModelmixExp,
      uniLgcModelmixUnknown
    ),
    mode=c(or=""),
    id.name="uniLgcNeedsP3"
  ),
  uniLgcEnableP2 <- rk.XML.connect(governor=uniLgcNeedsP2, client=uniSpinp2, set="enabled"),
  uniLgcEnableP3 <- rk.XML.connect(governor=uniLgcNeedsP3, client=uniSpinp3, set="enabled")
)

# ## wizard section

## JavaScript calculate
  RRreg.rk.js.p2.enabled <- rk.JS.vars(uniSpinp2, modifiers="enabled")
  RRreg.rk.js.p3.enabled <- rk.JS.vars(uniSpinp3, modifiers="enabled")
  RRreg.rk.js.calc <- rk.paste.JS(
    RRreg.rk.js.p2.enabled,
    RRreg.rk.js.p3.enabled,
    echo("RRUniResult <- RRuni("),
    js(
      if(varUniResponse){
        echo("\n  response=", varUniResponse)
      } else {},
      if(varUniData){
        echo(",\n  data=", varUniData)
      } else {},
      echo(",\n  model=\"", uniDrpModel, "\""),
      if(RRreg.rk.js.p3.enabled){
        echo(",\n  p=c(", uniSpinp1, ", ", uniSpinp2, ", ", uniSpinp3, ")")
      } else if(RRreg.rk.js.p2.enabled){
        echo(",\n  p=c(", uniSpinp1, ", ", uniSpinp2, ")")
      } else {
        echo(",\n  p=", uniSpinp1)
      },
      if(varUniGroup){
        echo(",\n  group=", varUniGroup)
      } else {}
    ),
    tf(uniChkMLest, opt="MLest", level=2),
    echo("\n)\n\n")
  )

## JavaScript printout
  RRreg.rk.js.print <- rk.paste.JS(
  )
