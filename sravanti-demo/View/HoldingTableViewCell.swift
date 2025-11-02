//
//  HoldingTableViewCell.swift
//  sravanti-demo
//
//  Created by Sravanti on 01/11/25.
//

import UIKit

class HoldingTableViewCell: UITableViewCell {
    
    private let symbolLabel = UILabel()
    private let quantityLabel = UILabel()
    private let ltpLabel = UILabel()
    private let pnlLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .systemBackground
        
        symbolLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        symbolLabel.textColor = .label
        
        quantityLabel.font = .systemFont(ofSize: 14)
        quantityLabel.textColor = .secondaryLabel
        
        ltpLabel.font = .systemFont(ofSize: 14)
        ltpLabel.textColor = .label
        ltpLabel.textAlignment = .right
        
        pnlLabel.font = .systemFont(ofSize: 14, weight: .medium)
        pnlLabel.textAlignment = .right
        
        let leftStack = UIStackView(arrangedSubviews: [symbolLabel, quantityLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 4
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        
        let rightStack = UIStackView(arrangedSubviews: [ltpLabel, pnlLabel])
        rightStack.axis = .vertical
        rightStack.spacing = 4
        rightStack.alignment = .trailing
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(leftStack)
        contentView.addSubview(rightStack)
        
        leftStack.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, paddingTop: 12, paddingBottom: 12,  leadingValue: 16)
        rightStack.anchor(leading: leftStack.trailingAnchor, trailing: contentView.trailingAnchor, leadingValue: 16, trailingValue: 16, centerY: leftStack.centerYAnchor)
        
        
    }
    
    func configure(with holding: Holding) {
        symbolLabel.text = holding.symbol
        quantityLabel.text = "NET QTY: \(holding.quantity)"
        
        let ltp = String(format: "LTP: ₹ %.2f", holding.ltp)
        ltpLabel.text = ltp
        
        let currentValue = holding.ltp * Double(holding.quantity)
        let investment = holding.avgPrice * Double(holding.quantity)
        let pnl = currentValue - investment
        
        
        let pnlText = "P&L: "
        let qtyText = "NET QTY:"
        let ltpText = "LTP:"
        //let amountText = String(format: "₹ %.2f", pnl)
        let amountText = pnl<0 ? "-₹" + String(format: "%.2f", abs(pnl)) :  String(format: "₹ %.2f", pnl)

        let quantityText = String(holding.quantity)
        let ltpSecondText = String(format: "₹ %.2f", holding.ltp)

        let attributedString1 = NSMutableAttributedString()
        let attributedString2 = NSMutableAttributedString()
        let attributedString3 = NSMutableAttributedString()

        // Grey "P&L:", "NET QTY:" & "LTP:"
        let greyAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        attributedString1.append(NSAttributedString(string: pnlText + "\u{00A0}", attributes: greyAttributes))
        attributedString2.append(NSAttributedString(string: qtyText + "\u{00A0}", attributes: greyAttributes))
        attributedString3.append(NSAttributedString(string: ltpText + "\u{00A0}", attributes: greyAttributes))

        // Green/Red amount
        let amountColor = pnl >= 0 ? UIColor.systemGreen : UIColor.systemRed
        let amountAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: amountColor,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        let quantityColor = UIColor.black
        let quantityAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: quantityColor,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]
        let ltpAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: quantityColor,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        
        attributedString1.append(NSAttributedString(string: amountText, attributes: amountAttributes))
        attributedString2.append(NSAttributedString(string: quantityText, attributes: quantityAttributes))
        attributedString3.append(NSAttributedString(string: ltpSecondText, attributes: ltpAttributes))

        pnlLabel.attributedText = attributedString1
        quantityLabel.attributedText = attributedString2
        ltpLabel.attributedText = attributedString3
        
    }
    
}
