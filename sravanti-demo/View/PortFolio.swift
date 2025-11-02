//
//  PortFolio.swift
//  sravanti-demo
//
//  Created by Sravanti on 01/11/25.
//

import UIKit

final class PortFolioView: UIView {
    
    // MARK: - UI Elements
    private let showPortFolioButton = UIButton(type: .system)
    private let currentValueLabel = UILabel()
    private let totalInvestmentLabel = UILabel()
    private let todaysPLLabel = UILabel()
    private let overallPLLabel = UILabel()
    private let detailsStack = UIStackView()
    private var isExpanded = false
    private var profitAndLossbuttonView = UIView()
    private var profitAndLossValueLabel = UILabel()
    private var profitAndLossAmountLabel = UILabel()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // Profit And LossAmount
        profitAndLossAmountLabel.text = "Profit & Loss*"
        profitAndLossAmountLabel.font = .systemFont(ofSize: 16)
        profitAndLossAmountLabel.textColor = .gray
        profitAndLossAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Show Portfolio
        showPortFolioButton.setTitleColor(.systemGray, for: .normal)
        showPortFolioButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        showPortFolioButton.contentHorizontalAlignment = .left
        showPortFolioButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        showPortFolioButton.tintColor = .gray
        showPortFolioButton.semanticContentAttribute = .forceRightToLeft
        showPortFolioButton.addTarget(self, action: #selector(toggleExpandCollapse), for: .touchUpInside)
        showPortFolioButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Profit & loss
        profitAndLossValueLabel.font = .systemFont(ofSize: 16)
        profitAndLossValueLabel.textColor = .gray
        profitAndLossValueLabel.textAlignment = .right
        profitAndLossValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Profit And Loss ButtonView
        profitAndLossbuttonView.addSubview(profitAndLossAmountLabel)
        profitAndLossbuttonView.addSubview(showPortFolioButton)
        profitAndLossbuttonView.addSubview(profitAndLossValueLabel)
        profitAndLossbuttonView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            profitAndLossAmountLabel.leadingAnchor.constraint(equalTo: profitAndLossbuttonView.leadingAnchor, constant: 16),
//            profitAndLossAmountLabel.centerYAnchor.constraint(equalTo: profitAndLossbuttonView.centerYAnchor),
//            
//            showPortFolioButton.leadingAnchor.constraint(equalTo: profitAndLossAmountLabel.trailingAnchor, constant: 8),
//            showPortFolioButton.centerYAnchor.constraint(equalTo: profitAndLossbuttonView.centerYAnchor),
//            showPortFolioButton.widthAnchor.constraint(equalToConstant: 10),
//            showPortFolioButton.heightAnchor.constraint(equalToConstant: 10),
//            
//            profitAndLossValueLabel.trailingAnchor.constraint(equalTo: profitAndLossbuttonView.trailingAnchor),
//            profitAndLossValueLabel.centerYAnchor.constraint(equalTo: profitAndLossbuttonView.centerYAnchor),
//            profitAndLossValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: showPortFolioButton.trailingAnchor, constant: 16),
//            
//            profitAndLossbuttonView.heightAnchor.constraint(equalToConstant: 24)
//        ])
        
        profitAndLossAmountLabel.anchor(leading: profitAndLossbuttonView.leadingAnchor, leadingValue: 16, centerY: profitAndLossbuttonView.centerYAnchor)
        showPortFolioButton.anchor(leading: profitAndLossAmountLabel.trailingAnchor, leadingValue: 8, centerY: profitAndLossbuttonView.centerYAnchor)
        showPortFolioButton.setWidth(width: 10)
        showPortFolioButton.setHeight(height: 10)
        profitAndLossValueLabel.anchor(leadingGreaterThanOrEqualTo: showPortFolioButton.trailingAnchor, trailing: profitAndLossbuttonView.trailingAnchor, trailingValue: 16,  centerY: profitAndLossbuttonView.centerYAnchor)
        profitAndLossbuttonView.setHeight(height: 24)

        
        // Details stack
        detailsStack.axis = .vertical
        detailsStack.spacing = 12
        detailsStack.translatesAutoresizingMaskIntoConstraints = false
        detailsStack.alpha = 0
        detailsStack.isHidden = true
        
        // Main layout stack
        let mainStack = UIStackView(arrangedSubviews: [detailsStack, profitAndLossbuttonView])
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)
        
        mainStack.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 16, paddingBottom: 16, leadingValue: 16, trailingValue: 16)
    }
    
    private func addRow(title: String, value: String, valueColor: UIColor = .gray) {
        let rowView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .gray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 16)
        valueLabel.textColor = valueColor
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rowView.addSubview(titleLabel)
        rowView.addSubview(valueLabel)
        
        titleLabel.anchor(leading: rowView.leadingAnchor, centerY: rowView.centerYAnchor)
        valueLabel.anchor(leadingGreaterThanOrEqualTo: titleLabel.trailingAnchor, trailing: rowView.trailingAnchor, leadingValue: 16, centerY: rowView.centerYAnchor)
        rowView.setHeight(height: 24)
        
        detailsStack.addArrangedSubview(rowView)
    }
    
    // MARK: - get value
    
    func configure(with summary: PortfolioSummary) {
        detailsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        addRow(title: "Current Value*", value: "₹ \(formatNumber(summary.currentValue))")
        addRow(title: "Total Investment*", value: "₹ \(formatNumber(summary.totalInvestment))")
        addRow(title: "Today's Profit & Loss*", value: summary.todaysPnL<0 ? "-₹\(formatNumber(abs(summary.todaysPnL)))" :  "₹ \(formatNumber(summary.todaysPnL))",
               valueColor: summary.todaysPnL >= 0 ? .systemGreen : .systemRed)
        
        separatorLine()
        
        let attributedString1 = NSMutableAttributedString()
        let greenAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.systemGreen,
                    .font: UIFont.systemFont(ofSize: 16, weight: .regular)
                ]
        let totalPnLText = "₹ \(formatNumber(summary.totalPnL))"
        let percentageText = "(\(formatNumber(summary.totalPnLPercentage))%)"
         attributedString1.append(NSAttributedString(string: totalPnLText, attributes: greenAttributes))
        let percentageAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGreen,
                    .font: UIFont.systemFont(ofSize: 12, weight: .regular)
                ]
        attributedString1.append(NSAttributedString(string: percentageText, attributes: percentageAttributes))
        profitAndLossValueLabel.attributedText = attributedString1
        profitAndLossValueLabel.textColor = summary.totalPnL >= 0 ? .systemGreen : .systemRed

    }
    
    // MARK: - Expand / Collapse
    @objc private func toggleExpandCollapse() {
        isExpanded.toggle()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.detailsStack.isHidden = !self.isExpanded
            self.detailsStack.alpha = self.isExpanded ? 1 : 0
            let rotation = self.isExpanded ? CGFloat.pi : 0
            self.showPortFolioButton.imageView?.transform = CGAffineTransform(rotationAngle: rotation)
        })
    }
    
    // MARK: - Helper: Title + Value formatting
    private func formattedText(title: String, value: String, valueColor: UIColor = .gray) -> NSAttributedString {
        let text = NSMutableAttributedString(
            string: "\(title)\n",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.gray
            ])
        text.append(NSAttributedString(
            string: value,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                .foregroundColor: valueColor
            ]))
        return text
    }
    
    // MARK: - Helper: Separator Line
    private func separatorLine() {
        let line = UIView()
        line.backgroundColor = .gray
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        line.translatesAutoresizingMaskIntoConstraints = false
        detailsStack.addArrangedSubview(line)
    }
    
    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
    }
}

