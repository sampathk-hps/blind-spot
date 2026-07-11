abstract final class AppStrings {
  // ── App ──────────────────────────────────────────────────────────────────────
  static const String appName = 'BlindSpot';
  static const String appVersion = '1.0.0';
  static const String defaultCurrency = 'USD';

  // ── Navigation ───────────────────────────────────────────────────────────────
  static const String navDashboard = 'Dashboard';
  static const String navInvoices = 'Invoices';
  static const String navInsurance = 'Insurance';
  static const String navSubscriptions = 'Subscriptions';
  static const String navSettings = 'Settings';

  // ── Greetings ────────────────────────────────────────────────────────────────
  static const String goodMorning = 'Good morning';
  static const String goodAfternoon = 'Good afternoon';
  static const String goodEvening = 'Good evening';

  // ── Auth ─────────────────────────────────────────────────────────────────────
  static const String welcomeBack = 'Welcome back';
  static const String signInToAccount = 'Sign in to your account';
  static const String createYourAccount = 'Create your account';
  static const String signUp = 'Sign Up';
  static const String signIn = 'Sign In';
  static const String signOut = 'Sign Out';
  static const String forgotPassword = 'Forgot Password?';
  static const String continueWithGoogle = 'Continue with Google';
  static const String orDivider = 'or';
  static const String noAccountPrompt = "Don't have an account? ";
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String fullNameLabel = 'Full Name';
  static const String googleSignInComingSoon = 'Google Sign-In coming soon';

  // ── Dashboard ────────────────────────────────────────────────────────────────
  static const String totalDue = 'Total Due';
  static const String monthlySpend = 'Monthly Spend';
  static const String activeInsurances = 'Active Insurances';
  static const String overdue = 'Overdue';
  static const String upcomingDeadlines = 'Upcoming Deadlines';
  static const String recentAdditions = 'Recent Additions';
  static const String viewAll = 'View all';
  static const String noUpcomingDeadlines =
      'No upcoming deadlines in the next 30 days.';
  static const String totalUnpaid = 'Total Unpaid';

  // ── Filter Labels ─────────────────────────────────────────────────────────────
  static const String filterAll = 'All';
  static const String filterUnpaid = 'Unpaid';
  static const String filterPaid = 'Paid';
  static const String filterOverdue = 'Overdue';
  static const String filterActive = 'Active';
  static const String filterPaused = 'Paused';
  static const String filterCancelled = 'Cancelled';
  static const String filterExpired = 'Expired';
  static const String filterExpiringSoon = 'Expiring Soon';

  // ── Invoices ─────────────────────────────────────────────────────────────────
  static const String invoices = 'Invoices';
  static const String addInvoice = 'Add Invoice';
  static const String editInvoice = 'Edit Invoice';
  static const String invoiceDetails = 'Invoice Details';
  static const String deleteInvoice = 'Delete Invoice';
  static const String deleteInvoiceConfirm =
      'Are you sure you want to delete this invoice?';
  static const String noInvoices = 'No invoices yet';
  static const String noInvoicesSubtitle =
      'Track your first invoice to get started';
  static const String saveInvoice = 'Save Invoice';
  static const String markAsPaid = 'Mark as Paid';

  // ── Invoice Form Labels ───────────────────────────────────────────────────────
  static const String vendorName = 'Vendor Name';
  static const String amount = 'Amount';
  static const String currency = 'Currency';
  static const String dueDate = 'Due Date';
  static const String category = 'Category';
  static const String status = 'Status';
  static const String notesOptional = 'Notes (Optional)';
  static const String tagsPlaceholder = 'Tags functionality goes here';
  static const String smartAutoTagging = 'Smart Auto-Tagging';

  // ── Insurance ────────────────────────────────────────────────────────────────
  static const String insurances = 'Insurances';
  static const String addInsurance = 'Add Insurance';
  static const String editInsurance = 'Edit Insurance';
  static const String insuranceDetails = 'Insurance Details';
  static const String deleteInsurance = 'Delete Insurance';
  static const String deleteInsuranceConfirm =
      'Are you sure you want to delete this insurance?';
  static const String noInsurances = 'No insurances yet';
  static const String noInsurancesSubtitle =
      'Track your first insurance policy to get started';
  static const String saveInsurance = 'Save Insurance';

  // ── Insurance Form Labels ─────────────────────────────────────────────────────
  static const String provider = 'Provider';
  static const String policyNumber = 'Policy Number';
  static const String insuranceType = 'Insurance Type';
  static const String premium = 'Premium';
  static const String billingCycleLabel = 'Billing Cycle';
  static const String renewalDate = 'Renewal Date';
  static const String coverageAmount = 'Coverage Amount (Optional)';

  // ── Subscriptions ─────────────────────────────────────────────────────────────
  static const String subscriptions = 'Subscriptions';
  static const String addSubscription = 'Add Subscription';
  static const String editSubscription = 'Edit Subscription';
  static const String subscriptionDetails = 'Subscription Details';
  static const String deleteSubscription = 'Delete Subscription';
  static const String deleteSubscriptionConfirm =
      'Are you sure you want to delete this subscription?';
  static const String noSubscriptions = 'No subscriptions yet';
  static const String noSubscriptionsSubtitle =
      'Track your first subscription to get started';
  static const String saveSubscription = 'Save Subscription';

  // ── Subscription Form Labels ──────────────────────────────────────────────────
  static const String serviceName = 'Service Name';
  static const String nextBillingDate = 'Next Billing Date';

  // ── Notifications ────────────────────────────────────────────────────────────
  static const String notifications = 'Notifications';

  // ── Premium ──────────────────────────────────────────────────────────────────
  static const String premiumTitle = 'BlindSpot Pro';
  static const String premiumSubtitle = 'Unlock the full potential';
  static const String premiumFeature = 'Premium Feature';
  static const String premiumLockMessage = 'Upgrade to access this feature';
  static const String upgradeToPremium = 'Upgrade to Pro';
  static const String unlockPremium = 'Unlock Premium';
  static const String startFreeTrial = 'Start 7-Day Free Trial';
  static const String restorePurchases = 'Restore Purchases';

  // ── Premium feature descriptions ──────────────────────────────────────────
  static const String featureCloudSync = 'Cloud Backup & Sync';
  static const String featureCloudSyncDesc =
      'Access your data across all your devices, securely.';
  static const String featureAi = 'AI Auto-Categorization';
  static const String featureAiDesc =
      'Gemini AI labels invoices and subscriptions for you.';
  static const String featureMultiDevice = 'Multi-Device Access';
  static const String featureMultiDeviceDesc =
      'Seamlessly switch between phone, tablet, and web.';

  // ── Pricing (placeholder — actual values come from store) ─────────────────
  static const String planAnnualLabel = 'Annual Plan';
  static const String planAnnualPrice = '\$29.99 / year';
  static const String planAnnualSavings = 'Save 50%';
  static const String planMonthlyLabel = 'Monthly Plan';
  static const String planMonthlyPrice = '\$4.99 / month';
  static const String iapPlaceholderPurchasing =
      'IAP Placeholder: Purchasing Annual...';
  static const String iapPlaceholderRestoring =
      'IAP Placeholder: Restoring...';

  // ── AI Features ──────────────────────────────────────────────────────────────
  static const String aiCategorize = 'AI Categorize';

  // ── Settings ─────────────────────────────────────────────────────────────────
  static const String settings = 'Settings';
  static const String settingsSectionAccount = 'Account';
  static const String settingsSectionPreferences = 'Preferences';
  static const String settingsSectionDataSecurity = 'Data & Security';
  static const String settingsProfile = 'Profile';
  static const String settingsDarkMode = 'Dark Mode';
  static const String settingsBiometric = 'Biometric Authentication';
  static const String settingsSyncStatus = 'Sync Status';
  static const String settingsSyncLocalOnly = 'Local Only (Free Tier)';
  static const String settingsExportData = 'Export Data';
  static const String settingsProfileComingSoon = 'Profile coming soon';
  static const String settingsExportComingSoon = 'Export coming soon';
  static const String settingsNotificationsLabel = 'Notifications';

  // ── Onboarding ───────────────────────────────────────────────────────────────
  static const String onboarding1Title = 'Track Everything';
  static const String onboarding1Body =
      'All your invoices, insurances, and subscriptions in one place.';
  static const String onboarding2Title = 'Never Miss a Date';
  static const String onboarding2Body =
      'Get timely reminders for payments and renewals.';
  static const String onboarding3Title = 'Bank-level Security';
  static const String onboarding3Body =
      'Your data is encrypted with AES-256 for maximum privacy.';
  static const String onboardingSkip = 'Skip';
  static const String onboardingNext = 'Next';
  static const String onboardingGetStarted = 'Get Started';

  // ── Common Actions ────────────────────────────────────────────────────────────
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String save = 'Save';
  static const String confirm = 'Confirm';
  static const String required = 'Required';
  static const String invalidNumber = 'Invalid number';
  static const String passwordTooShort = 'Too short';
  static const String comingSoon = 'Coming soon';

  // ── IAP Product IDs ───────────────────────────────────────────────────────────
  static const String iapMonthlyId = 'blindspot_premium_monthly';
  static const String iapAnnualId = 'blindspot_premium_annual';

  // ── Hive Box Names ────────────────────────────────────────────────────────────
  static const String hiveBoxInvoices = 'invoices';
  static const String hiveBoxInsurances = 'insurances';
  static const String hiveBoxSubscriptions = 'subscriptions';
  static const String hiveBoxUserPrefs = 'user_prefs';
  static const String hiveBoxNotificationSettings = 'notification_settings';

  // ── Secure Storage Keys ───────────────────────────────────────────────────────
  static const String secureKeyHiveEncryption = 'blindspot_hive_key';
  static const String secureKeyAesEncryption = 'blindspot_aes_key';
  static const String secureKeyGemini = 'blindspot_gemini_key';

  // ── SharedPreferences Keys ────────────────────────────────────────────────────
  static const String prefThemeMode = 'theme_mode';
  static const String prefOnboardingComplete = 'onboarding_complete';
  static const String prefBiometricEnabled = 'biometric_enabled';
  static const String prefNotificationLeadTime = 'notification_lead_days';
  static const String prefDailyDigestEnabled = 'daily_digest_enabled';
  static const String prefUserTier = 'user_tier';
}
