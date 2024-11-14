import UIKit

final class CheckButton: UIButton {
    
    // MARK: - Properties
    
    var isChecked = false {
        didSet { animateButtonAppearance() }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 34, height: 34)
    }
    
    private var color: UIColor? {
        didSet { animateButtonAppearance() }
    }
    private var handler: (() -> Void)?
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        setupButtonAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(with color: UIColor?, handler: @escaping () -> Void) {
        self.color = color
        self.handler = handler
    }

    private func setupButtonAppearance() {
        layer.masksToBounds = true
        layer.cornerRadius = 17
        imageView?.tintColor = .whiteApp
        addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func updateButtonAppearance() {
        let imageName = isChecked ? "checkmark" : "plus"
        setImage(UIImage(systemName: imageName), for: .normal)
        backgroundColor = isChecked ? color?.withAlphaComponent(0.3) : color
    }
    
    private func animateButtonAppearance() {
        UIView.animate(withDuration: 0.15, animations: {
            self.updateButtonAppearance()
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.transform = CGAffineTransform.identity
            }
        })
    }
    
    @objc private func handleButtonTap() {
        isChecked.toggle()
        handler?()
    }
    
}
