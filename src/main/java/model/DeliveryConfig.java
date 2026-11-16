package model;

public class DeliveryConfig {

    private int    configId;
    private String methodKey;
    private String methodName;
    private double fee;
    private String description;

    public DeliveryConfig() {}

    public DeliveryConfig(int configId, String methodKey, String methodName,
                          double fee, String description) {
        this.configId    = configId;
        this.methodKey   = methodKey;
        this.methodName  = methodName;
        this.fee         = fee;
        this.description = description;
    }

    public int    getConfigId()             { return configId; }
    public void   setConfigId(int v)        { this.configId = v; }

    public String getMethodKey()            { return methodKey; }
    public void   setMethodKey(String v)    { this.methodKey = v; }

    public String getMethodName()           { return methodName; }
    public void   setMethodName(String v)   { this.methodName = v; }

    public double getFee()                  { return fee; }
    public void   setFee(double v)          { this.fee = v; }

    public String getDescription()          { return description; }
    public void   setDescription(String v)  { this.description = v; }
}
