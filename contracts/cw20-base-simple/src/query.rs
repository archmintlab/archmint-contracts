use schemars::JsonSchema;
use serde::{Deserialize, Serialize};

use cosmwasm_std::{Addr};

#[derive(Serialize, Deserialize, Clone, PartialEq, JsonSchema, Debug, Default)]
pub struct MarketingInfoResponse {
    /// A URL pointing to the project behind this token.
    pub project: Option<String>,
    /// A longer description of the token and it's utility. Designed for tooltips or such
    pub description: Option<String>,
    /// The address (if any) who can update this data structure
    pub marketing: Option<Addr>,
}
